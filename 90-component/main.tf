module "components" {
    for_each = var.components
    #   source = "../../terraform-roboshop-component"
      source = "git::https://github.com/dharsha27/terraform-roboshop-component.git?ref=main"
    #   project= ${var.project}
      environment =var.environment
      component =each.key
      app_version = each.value.app_version

}