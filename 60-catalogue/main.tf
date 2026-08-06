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
      "sudo sh /tmp/bootstrap.sh catalogue ${var.environment}-${var.app_version}"
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

# Launch template resource tags
tags = merge(
    {
        Name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    },
    local.common_tags
  )

}