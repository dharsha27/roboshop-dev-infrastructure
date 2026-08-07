resource "aws_lb" "backend_alb" {
  name               = "${local.common_name}-backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  subnets            = local.private_subnet_ids

  enable_deletion_protection = false
  # allow_overwrite=true

  

  tags = merge(

    {
        Name= "${local.common_name}-backend-alb"    
    },
    local.common_tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"
  # allow_overwrite=true

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "<h1>Hi this is the aws listener</h>"
      status_code  = "200"
    }
  }

}

resource "aws_ssm_parameter" "backend_alb_listener_arn" {
 
  name  = "/${var.project}/${var.environment}/backend_alb_listener_arn" # /roboshop/dev/backend_alb_sg_id, /roboshop/dev/mongodb_sg_id
  type  = "String"
  value = aws_lb_listener.http.arn
  overwrite = true
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.environment}.devopspractice.online"
  type    = "A"

  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
  allow_overwrite=true

}
