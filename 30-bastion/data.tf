data "aws_ssm_parameter" "bastion_sg_id" {

  name = "/${var.project}/${var.environment}/bastion_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {

  name = "/${var.project}-${var.environment}/public_subnet_ids"
}

data "aws_security_group" "bastion" {
  name = "${var.project}-${var.environment}-bastion"
}

output "sg_id" {
  value = data.aws_security_group.bastion.id
}

 data "aws_ami" "joindevops" {

  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]

  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]

  }

  filter {
    name   = "architecture"
    values = ["x86_64"]

  }

}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["roboshop-dev"]
  }
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}