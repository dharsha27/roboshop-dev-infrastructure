resource "aws_instance" "catalogue" {
  ami           = data.aws_ami.joindevops.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id = local.private_subnet_id
  
  
  tags = merge(
    {
        Name = "${local.common_name}-catalogue"
    },
    local.common_tags
  )
}



resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = "DevOps321"
    host        = aws_instance.catalogue.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue ${var.environment}"
    ]
  }
}


# 2. Control the runtime power state separately
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped" # Valid options: "running" or "stopped"
  depends_on  = [terraform_data.catalogue]

  # Optional: set to true if you need to force-kill a frozen instance
  # force = false 
}

resource "aws_ami_from_instance" "catalogue"{
  name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
  source_instance_id= aws_instance.catalogue.id
  depends_on= [aws_ec2_instance_state.catalogue]

 tags = merge(
    {
        Name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    },
    local.common_tags
  )

}


resource "aws_launch_template" "catalogue" {

  name = "${local.common_name}-catalogue"
  image_id = aws_ami_from_instance.catalogue.id  #AMI ID
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  update_default_version = true
  vpc_security_group_ids = [local.catalogue_sg_id]

# Once instance are created these will become the instance tags
  tag_specifications {
    resource_type = "instance"

    tags = merge(
    {
        Name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    },
    local.common_tags
  )
}
 # Once instance are created these will become the volume tags
   tag_specifications {
    resource_type = "volume"

    tags = merge(
    {
        Name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    },
    local.common_tags
  )
 }
# Launch template resource tags
tags = merge(
    {
        Name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    },
    local.common_tags
  )

}

resource "aws_lb_target_group" "test" {
  name     = "${local.common_name}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay=30

 health_check  {
   
   healthy_threshold = 2
   interval = 10
   matcher ="200-299"
   path = "/health"
   port=8080
   protocol ="HTTP"  
   timeout=5
   unhealthy_threshold=2


 }
}

# resource "aws_placement_group" "test" {
#   name     = "${local.common_name}-catalogue"
#   strategy = "cluster"
# }

# resource "aws_autoscaling_group" "catalogue" {
#   name                      = "${local.common_name}-catalogue"
#   max_size                  = 10
#   min_size                  = 1
#   health_check_grace_period = 300
#   health_check_type         = "ELB"
#   desired_capacity          = 4
#   force_delete              = false
 
#   launch_template {
#     id      = aws_launch_template.catalogue.id
#     version = aws_launch_template.example.latest_version
#   }
#   vpc_zone_identifier       = [aws_subnet.example1.id, aws_subnet.example2.id]

#   instance_maintenance_policy {
#     min_healthy_percentage = 90
#     max_healthy_percentage = 120
#   }

#   initial_lifecycle_hook {
#     name                 = "foobar"
#     default_result       = "CONTINUE"
#     heartbeat_timeout    = 2000
#     lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

#     notification_metadata = jsonencode({
#       foo = "bar"
#     })

#     notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#     role_arn                = "arn:aws:iam::123456789012:role/S3Access"
#   }

#   tag {
#     key                 = "foo"
#     value               = "bar"
#     propagate_at_launch = true
#   }

#   timeouts {
#     delete = "15m"
#   }

#   tag {
#     key                 = "lorem"
#     value               = "ipsum"
#     propagate_at_launch = false
#   }
# }