locals {
  bastion_sg_id    = data.aws_ssm_parameter.bastion_sg_id.value
  common_name      = "${var.project}-${var.environment}"
  ami_id           = data.aws_ami.joindevops.id
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  vpc_id=data.aws_vpc.selected.id
  sg_id=data.aws_security_group.bastion.id

  common_tags = {
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Terraform   = "true"
  }
}