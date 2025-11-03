module "name" {
   source = "../day-2-basic-code"   #added day-2 update only instance
   ami_id = "ami-07860a2d7eb515d9a"
   type = "t3.micro"
}