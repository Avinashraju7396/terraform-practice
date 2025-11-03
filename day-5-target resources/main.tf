resource "aws_instance" "name" {
  ami           = "ami-0e6be795b21969e1d"
  instance_type = "t3.micro"
}
resource "aws_s3_bucket" "name" {
  bucket = "avinashhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"

}
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"

}
#   target-resources
# 1-single resources-->terraform <plan(or)apply(or)destroy> -target=aws_<resources name>.name
#2-mulit resources--> terraform <plan(or)apply(or)destroy> -target=aws_<resources name>.name<space>-target=aws_<another_resources name>.name
#$ terraform plan -target=aws_s3_bucket.name -target=aws_instance" "name"-edit