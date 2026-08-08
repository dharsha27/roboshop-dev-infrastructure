
variable "domain_name" {
  default = "devopspractice.online"
}

variable "zone_id" {
  default = "Z02304293I0EIMA6V7PSK"
}

variable "environment" {
  default = "dev"
}

variable "components" {
 
 default ={
  
  catalogue = {
     rule_priority =10
     app_version= "v3"
  }

  user = {
     rule_priority =20
     app_version= "v3"
  }

  cart = {
     rule_priority =30
     app_version= "v3"
  }

  shipping = {
     rule_priority =40
     app_version= "v3"
  }

  payment = {
     rule_priority =50
     app_version= "v3"
  }

  
  
 }  


}