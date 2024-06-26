output "vpc_id" {
  description = "VPC Id for created VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet.*.id

}