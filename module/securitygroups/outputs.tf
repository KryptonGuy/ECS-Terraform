output "server-lb-sg" {
  value = aws_security_group.server-lb-sg.id
}

output "ecs_service-sg" {
  value = aws_security_group.ecs-service-sg.id
}

output "ecs_service-sg-arn" {
  value = aws_security_group.ecs-service-sg.arn
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "db_security_group_id" {
  value = aws_security_group.db-sg.id
}
