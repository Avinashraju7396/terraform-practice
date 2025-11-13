
variable "cidr_block" {
  type        = string
  default = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable "subnet_1_cidr" {
  type        = string
  default = "10.0.1.0/24"
  description = "CIDR for subnet 1"
}

variable "subnet_2_cidr" {
  type        = string
  default = "10.0.2.0/24"
  description = "CIDR for subnet 2"
}

variable "az1" {
  type        = string
  default = "us-east-1b"
  description = "Availability zone for subnet 1"
}

variable "az2" {
  type        = string
  default = "us-east-1a"
  description = "Availability zone for subnet 2"
}

variable "name_prefix" {
  type    = string
  default = "avinash"
}
