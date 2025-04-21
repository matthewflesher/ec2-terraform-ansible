terraform {
  backend "s3" {
    bucket         = "matt34567-terraform-state"
    key            = "selenium-grid/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"  
    encrypt        = true
  }
}
