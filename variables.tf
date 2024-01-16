variable "env" {
  type    = string
  default = "dev"
}

variable "versioning" {
  type    = string
  default = "Enabled"
}

variable "create_vpc" {
  type    = bool
  default = true
}

/*
variable "region" {
  type    = string
  default = "us-east-1"
}
*/