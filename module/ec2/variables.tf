variable "ec2_launch_template_name" {
  type        = string
  description = "Name of EC2 Launch Template"
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI ID for EC2 Instance"

}

variable "ec2_instance_type" {
  type        = string
  description = "Instance Type for EC2 Instance"
}

variable "ec2_role_arn" {
  type        = string
  description = "IAM Role ARN for EC2 Instance"
}

variable "ec2_security_group" {
  type        = list(string)
  description = "Security Group for EC2 Instance"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of ECS Cluster"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of Private Subnets"
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

variable "db_security_groups" {
  type        = list(string)
  description = "Security Group for DB Instance"
}