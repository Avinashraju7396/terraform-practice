terraform {
  backend "s3" {
    bucket = "kjhgfdfghjklkmjnhb"   #create a new bucket
    key    = "day-4/terraform.tfstate"
    use_lockfile = true # to use s3 native locking 1.19 version above
    region = "us-east-1" 
  }
}