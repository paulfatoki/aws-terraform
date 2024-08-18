terraform {
  backend "s3" {
    bucket = "my-terraform-bucket-205"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }
}