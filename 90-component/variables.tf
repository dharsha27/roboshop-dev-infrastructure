
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
    #  rule_priority =10
     app_version= "v3"
  }

 }  


}