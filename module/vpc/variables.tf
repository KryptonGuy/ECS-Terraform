variable "projectname" {
  type        = string
  description = "Project Name"
}

variable "vpc_name" {
  type        = string
  description = "Name of VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "vpc_cidr" {
  type        = string
  description = "Cidr for VPC"
}

variable "environment" {
  type        = string
  description = "Project Environment"
}
