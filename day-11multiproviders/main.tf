resource "aws_instance" "name" {
  ami="ami-0cae6d6fe6048ca2c"
  subnet_id ="subnet-04b1075260cd1ef79" 
  instance_type = "t2.micro"
  tags = {
    Name = "avinash"
  }

}

resource "aws_s3_bucket" "name" {
    bucket = "dcfvbnmiiiiiiiiii"
    provider = aws.oregon
  
}


#this is multi providers concept and it create two resouces in two diffrent regions