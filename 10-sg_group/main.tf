module "sg" {
#   source ="C:/Devops/KeyGen/shell-practice/terraform-aws-sg"
  count       = length(var.sg_names)
  source      = "git::https://github.com/dharsha27/terraform-aws-sg.git?ref=main"
  project     = var.project
  environment = var.environment
  vpc_id      = local.vpc_id
  sg_name     = replace(var.sg_names[count.index], "_", "-")

}