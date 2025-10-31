terraform {
  backend "s3" {
    bucket = "kjhgfdfghjklkmjnhb"   #create a new bucket
    key    = "day-4/terraform.tfstate"
    region = "us-east-1" 
  }
}