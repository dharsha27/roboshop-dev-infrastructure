resource "aws_instance" "bastion" {

  ami                    = data.aws_ami.joindevops.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_id
  user_data = templatefile("${path.module}/bastion.sh.tftpl",{
    partition_number = 4
    extend_size = 30
  })
  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(
    {
      Name = "${local.common_name}-bastion"
    },
    local.common_tags
  )

}



