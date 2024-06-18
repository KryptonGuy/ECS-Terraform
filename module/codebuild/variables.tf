variable "build_project_name" {
  type        = string
  description = "Name of CodeBuild Project"
}

variable "stage_test_name" {
  type        = string
  description = "Name of CodeBuild Stage Test"
}


variable "code_build_iam_arn" {
  type = string
}

variable "account_id" {
  type = string
}

variable "ecr_repo_name" {
  type = string
}

variable "region" {
  type = string
}


