

terraform {
  backend "s3" {
    bucket  = ""
    key     = ""
    region  = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt = true
  }
}
