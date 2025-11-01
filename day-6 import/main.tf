resource "aws_instance" "name" {
    ami = "ami-0e6be795b21969e1d"
    instance_type = "t3.micro"
    tags = {
      Name = "ec2"
    }
  
}

