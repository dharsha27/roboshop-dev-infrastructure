locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
# vpc_id= aws_vpc.main.id
}