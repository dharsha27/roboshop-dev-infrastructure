variable "project" {
  type=string
  default = "roboshop"
}

variable "environment" {
  type=string
  default = "dev"
}

variable "sg_names" {

  type    = list

  default = ["mongodb","redis","mysql","rabbitmq","catalogue","user","cart",
  "shipping","payment","frontend","backend_alb","frontend_alb","bastion","vpn"]


}
