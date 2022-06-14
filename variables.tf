variable "vpc_id" {
  default = ""
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "component_name" {
  default = "kojitechs"
}

variable "name" {
  type    = list(any)
  default = ["registration_app1", "registration_app2"]
}

variable "d_name" {
  default = {
    default = "alloyzio.click"
 #   sbx  = "alloyzio.click"
  }
}



variable "subject_alternative_names" {
  type    = list
}