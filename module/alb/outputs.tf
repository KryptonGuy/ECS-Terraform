output "alb_dns_name" {
  value = aws_lb.server.dns_name
}

output "alb_arn" {
  value = aws_lb.server.arn
}

output "ecs_service_prod_tg" {
  value = aws_lb_target_group.server_tg.arn
}

output "ecs_service_stage_tg" {
  value = aws_lb_target_group.stage-tg.arn
}