output "ecs_cluster_name" {
  value = aws_ecs_cluster.Cluster.name

}

output "ecs_service_name" {
  value = aws_ecs_service.server.name

}

output "ecs_cp_arn" {
  value = aws_ecs_capacity_provider.ecs_cp.arn

}

output "ecs_cp_name" {
  value = aws_ecs_capacity_provider.ecs_cp.name

}