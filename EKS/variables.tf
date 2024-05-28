variable "vpc_cidr" {
  description = "VPC CIDR"
  type = string
}

variable "public_subnets" {
  description = "public subnets"
  type = list(string)
}

variable "private_subnets" {
  description = "Private Subnets"
  type = list(string)
}

variable "instance_types" {
  description = "Node Instances"
  type        = list(string)
}
