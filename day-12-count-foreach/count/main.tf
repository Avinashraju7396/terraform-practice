provider "aws" {
    region = "us-east-1"
  
}

# resource "aws_instance" "name" {
#     ami = "ami-07860a2d7eb515d9a"
#     instance_type = "t2.micro"
#     count = 2
#     # tags = {
#     #   Name = "dev"
#     # }
#   tags = {
#       Name = "dev-${count.index}"
#     }
# }

variable "env" {
    type = list(string)
    default = [ "test","dev"]
  
}

resource "aws_instance" "name" {
    ami = "ami-07860a2d7eb515d9a"
    subnet_id = "subnet-04b1075260cd1ef79"
    instance_type = "t2.micro"
    count = length(var.env)
    # tags = {
    #   Name = "dev"
    # }
  tags = {
      Name = var.env[count.index]
    }
}