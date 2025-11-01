resource "aws_instance" "name" {
  ami           = "ami-0e6be795b21969e1d"
  count         = 1
  instance_type = "t2.micro"

  tags = {
    Name = "public1"
  }

  lifecycle {
    create_before_destroy = true  // # create new instance before destroying old one
  }
    lifecycle {
    ignore_changes = [instance_type] // # ignore instance_type changes on apply
  }
   
   lifecycle {
    prevent_destroy = true   //# prevents deletion via `terraform destroy` or accidental deletes
  
   }
}

