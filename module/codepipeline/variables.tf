variable "codepipelinename" {
  type        = string
  description = "CodePipeline Name"
}

variable "code_pipeline_iam_arn" {
  type = string
}

variable "code_build_name" {
  type = string
}

variable "codepipelinebucket_id" {
  type = string
}

variable "branch" {
  type        = string
  description = "Branch Name"
}

variable "FullRepositoryId" {
  type        = string
  description = "FullRepositoryId"
}

variable "ConnectionArn" {
  type        = string
  description = "Github Connection ARN"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Cluster Name of ECS"
}

variable "ecs_service_name" {
  type        = string
  description = "Service Name of ECS"
}