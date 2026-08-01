module "vpc"{

    # source="../tf-aws-vpc"
    source="git::https://github.com/dharsha27/tf-aws-vpc.git?ref=main"
    project=var.project
    environment=var.environment
    is_peering_required=false
    

}