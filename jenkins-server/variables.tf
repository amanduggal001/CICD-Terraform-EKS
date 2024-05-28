variable "vpc_cidr" {
  description = "VPC CIDR"
  type = string
}

variable "public_subnets" {
  description = "public subnets"
  type = list(string)
}

variable "instance_type" {
  description = "Instance Type"
  type = string
}

variable "key_name" {
  description = "Key Pair name"
  type = string
}

variable "ami" {
  description = "ami id"
  type = string
}
