variable "environment" {
  type        = string
  description = "Project Environment"
}

variable "projectname" {
  type        = string
  description = "Project Name"
}

variable "FullRepositoryId" {
  type        = string
  description = "Full Repository ID"
}

variable "githubBranch" {
  type        = string
  description = "Github Branch"
}

variable "github_connection_arn" {
  type        = string
  description = "Github Connection ARN"
}

variable "ssl_certificate_arn" {
  type        = string
  description = "SSL Certificate ARN"
}

variable "region" {
  type        = string
  description = "Region Name"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of Capacity instances"
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of Capacity instances"
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of Capacity instances"
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI ID for Container EC2"
}

variable "ec2_instance_type" {
  type        = string
  description = "Container EC2 instance type"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}


variable "db_ami_id" {
  type        = string
  description = "AMI ID for DB Instance"

}

variable "db_instance_type" {
  type        = string
  description = "Instance Type for DB Instance"
}

variable "db_key_name" {
  type        = string
  description = "Key Name for DB Instance"
}