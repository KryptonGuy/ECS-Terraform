variable "vpc_id" {
  type        = string
  description = "Id of VPC"
}

variable "alb_name" {
  type        = string
  description = "Name of ALB"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of availability zones"
}

variable "tg_name" {
  type        = string
  description = "Name of Target group"
}

variable "ssl_certificate" {
  type        = string
  description = "Arn of certificate for HTTPS"
}


variable "ecs_service-sg" {
  type        = string
  description = "Security Group of ECS Service"
}

variable "server-lb-sg" {
  type        = string
  description = "Security Group of ALB"
}