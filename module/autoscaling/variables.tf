variable "ecs_cluster_name" {
  type        = string
  description = "Cluster Name of ECS"
}

variable "ecs_service_name" {
  type        = string
  description = "Service Name of ECS"
}

# variable "autoscaling_memory_target_value" {
#   type        = number
#   description = "Target Value of Memory Utilization for AutoScaling"
# }

# variable "autoscaling_cpu_target_value" {
#   type        = number
#   description = "Target Value of Memory Utilization for AutoScaling"
# }

variable "min_capacity" {
  type        = number
  description = "Minimum Capacity of ECS Service"
}

variable "max_capacity" {
  type        = number
  description = "Maximum Capacity of ECS Service"

}

variable "desired_capacity" {
  type        = number
  description = "Desired Capacity of ECS Service"
}

variable "ec2_launch_template_id" {
  type        = string
  description = "Launch Template ID of EC2"

}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of Public subnet"
}