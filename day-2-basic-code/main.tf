resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-test"
  }
}

resource "aws_subnet" "name" {
  vpc_id                  = aws_vpc.name.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true  # important to get public IP

  tags = {
    Name = "subnet-1"
  }
}

resource "aws_instance" "name" { 
  ami           = var.ami_id
  instance_type = var.type
  subnet_id     = aws_subnet.name.id

  associate_public_ip_address = true  # important for SSH

  tags = {
    Name = "test"
  }
}
