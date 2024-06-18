resource "aws_ecr_repository" "server-repo" {
  name = var.repo_name
  image_scanning_configuration {
    scan_on_push = true
  }

}

