variable "ecs_cluster_name" {
  type        = string
  description = "Name of ECS cluster"
}

variable "namespace" {
  type        = string
  description = "Service discovery http Namespace"
  default     = "production"
}

variable "td_name" {
  type        = string
  description = "Task Definition Name"
}

variable "ecs_service_iam_arn" {
  type        = string
  description = "ARN of ECS Service Role"
}

variable "container_role_arn" {
  type        = string
  description = "ARN of Container Role"
}

variable "server_task_cpu" {
  type        = number
  description = "CPU for ECS Task"
}

variable "server_task_memory" {
  type        = number
  description = "Memory for ECS Task"
}

variable "ecs_server_service_name" {
  type        = string
  description = "Name of ECS Service"
}

variable "prod_container_name" {
  type        = string
  description = "Name of prod container"
}

variable "stage_container_name" {
  type        = string
  description = "Name of stage container"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of availability zones"
}

variable "repo_url" {
  type        = string
  description = "URL of ECR Repository"
}

variable "ecs_service-sg" {
  type        = string
  description = "Security Group of ECS Service"
}

variable "alb_ecs_prod_tg" {
  type        = string
  description = "Prod Target Group ARN of ALB"
}

variable "alb_ecs_stage_tg" {
  type        = string
  description = "Stage Target Group ARN of ALB"
}

variable "ec2_launch_template_arn" {
  type        = string
  description = "Launch Template ARN of EC2"
}

variable "ec2_asg_arn" {
  type        = string
  description = "AutoScaling Group ARN of EC2"
}

variable "aws_ecs_cp_name" {
  type        = string
  description = "Name of ECS Capacity Provider"
}


variable "private_bucket_name" {
  type        = string
  description = "Name of Private Bucket"
}

variable "public_bucket_name" {
  type        = string
  description = "Name of Public Bucket"
}