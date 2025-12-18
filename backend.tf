terraform {
  required_version = ">= 1.5"

  backend "s3" {
    bucket         = "nti-tf-state-654654559582"
    key            = "nti_project_terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nti-terraform-locks"
    encrypt        = true
  }

}
