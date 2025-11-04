resource "aws_instance" "name" { 
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = "subnet-0bd1813ca995152b9"
    tags = {
      Name = "server1122"
    }
}
