variable "backend_region" {
  type    = string
  default = "us-east-1"
}

variable "source_region" {
  type    = string
  default = "us-west-1"
}

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

