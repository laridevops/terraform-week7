#Create a DynamoDB table that will be used for state locking.
#This ensures that only one Terraform operation can be run at a time
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform_lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

#Now that you have your S3 bucket and DynamoDB table in place, configure your Terraform project to use them as the backend for state storage.
terraform {
  backend "s3" {
    bucket         = "laridevops"
    key            = "Terraform-week7/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform_lock"
  }
}

