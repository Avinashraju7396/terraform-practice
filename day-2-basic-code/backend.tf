terraform {
  backend "s3" {
    bucket = "kjhgfdfghjklkmjnhb "
    key    = "day-2/terraform.tfstate"
    region = "us-east-1"
  }
}