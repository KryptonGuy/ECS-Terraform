provider "aws" {
  region  = var.region

  default_tags {
    tags = {
      env     = var.environment
      project = var.projectname
    }
  }
}
