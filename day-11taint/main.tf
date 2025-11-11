#########################################
# VPC
#########################################
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

#########################################
# Subnet
#########################################
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet"
  }
}

#########################################
# Security Group
#########################################
resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg"
  }
}

#########################################
# EC2 Instance
#########################################
resource "aws_instance" "my_ec2" {
  ami           = "ami-0cae6d6fe6048ca2c"  # Amazon Linux 2 AMI (Free Tier eligible)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "my-ec2-instance"
  }
}

#########################################
# S3 Bucket
#########################################
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-s3-bucket-example-123458030767"

  tags = {
    Name = "my-s3-bucket"
  }
}


#terraform taint is nothing but a particular resouce to be performed for example ;terraform taint aws_instance.my_ec2 if use this command that resource will destroy and it will create same resource