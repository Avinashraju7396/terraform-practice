resource "aws_instance" "import" {
  ami="ami-0e6be795b21969e1d"
  count = 1
  instance_type = "t3.small"
  
  tags = {
    Name = "test"
  } 
lifecycle {
 create_before_destroy = true

}

}

