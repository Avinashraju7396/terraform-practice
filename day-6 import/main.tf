resource "aws_instance" "name" {
    ami = "i-04a9ef2c1c2923605"
    instance_type = "t3.micro"
    tags = {
      Name = "ec2"
    }
  
}

#terraform import aws_instance.name i-04a9ef2c1c2923605  chnage instance id that already exit 

resource "aws_s3_bucket" "name" {
    bucket = "avinash0123"
  
}
#terraform import aws_s3_bucket.name avinash0123   here change bucket name that already exist

