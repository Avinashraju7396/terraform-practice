resource "aws_instance" "name" {
  ami                         = "ami-0157af9aea2eef346" # Amazon Linux 2
  instance_type               = "t2.micro"              # <- changed from t3.micro
  subnet_id                   = "subnet-04b1075260cd1ef79"
  associate_public_ip_address = true

  tags = {
    Name = "ec2"
  }
}
