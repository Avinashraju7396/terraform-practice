
resource "aws_instance" "name" {
    ami = "ami-07860a2d7eb515d9a"
    subnet_id = "subnet-096f7e23ee6d4f86b"
    count = 5
    instance_type = "t3.micro"
    tags = {
        Name = "ec2-1"
      
    }
  
}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name ="one12"
    }
}
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "my subnet1"
      
    }
  
}
