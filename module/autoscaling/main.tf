# EC2 Autoscaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_capacity
  min_size         = var.min_capacity

  health_check_grace_period = 120
  vpc_zone_identifier       = var.public_subnets

  mixed_instances_policy {

    instances_distribution {
      on_demand_base_capacity                  = 1
      on_demand_percentage_above_base_capacity = 25
      on_demand_allocation_strategy            = "prioritized"

      spot_allocation_strategy = "capacity-optimized-prioritized"

    }

    launch_template {
      launch_template_specification {
        launch_template_id = var.ec2_launch_template_id
        version            = "$Latest"
      }
    }
  }

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }


}


# resource "aws_appautoscaling_target" "dev_to_target" {
#   max_capacity       = 3
#   min_capacity       = 1
#   resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "dev_to_memory" {
#   name               = "dev-to-memory"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.dev_to_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.dev_to_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.dev_to_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }

#     target_value = var.autoscaling_memory_target_value
#   }
# }

# resource "aws_appautoscaling_policy" "dev_to_cpu" {
#   name               = "dev-to-cpu"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.dev_to_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.dev_to_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.dev_to_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value = var.autoscaling_cpu_target_value
#   }
# }