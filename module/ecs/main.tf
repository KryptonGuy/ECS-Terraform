# Service Discovery Namespace

resource "aws_service_discovery_http_namespace" "server" {
  name        = var.namespace
  description = "Namespace of ECS"
}

# ECS Cluster Defination

resource "aws_ecs_cluster" "Cluster" {
  name = var.ecs_cluster_name


  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.server.arn
  }
}


# ECS Capacity Provider

resource "aws_ecs_capacity_provider" "ecs_cp" {
  name = var.aws_ecs_cp_name

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.ec2_asg_arn
    managed_draining       = "ENABLED"

    managed_scaling {
      instance_warmup_period    = 90
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

# Capacity Provider Strategy

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.Cluster.name

  capacity_providers = [aws_ecs_capacity_provider.ecs_cp.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_cp.name
    base              = 1
    weight            = 100
  }
}

# ECS Service Task Definition
resource "aws_ecs_task_definition" "server" {
  family                   = var.td_name
  execution_role_arn       = var.ecs_service_iam_arn
  task_role_arn            = var.container_role_arn
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  container_definitions = jsonencode([
    {
      name      = var.prod_container_name
      image     = var.repo_url
      cpu       = 512
      memory    = 200
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]

      environment = [
        {
          name  = "PORT"
          value = "3000"
        }
      ]

      secrets = [
        
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${var.td_name}-prod"
          "awslogs-create-group" = "true"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }

    },
    {
      name      = var.stage_container_name
      image     = var.repo_url
      cpu       = 512
      memory    = 200
      essential = true
      portMappings = [
        {
          containerPort = 3001
          hostPort      = 3001
        }
      ]

      environment = [
        {
          name  = "PORT"
          value = "3001"
        }
      ]

      secrets = [
      ]

    logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${var.td_name}-prod"
          "awslogs-create-group" = "true"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }

    }

  ])

}

## ECS Service
resource "aws_ecs_service" "server" {
  name            = var.ecs_server_service_name
  cluster         = aws_ecs_cluster.Cluster.id
  task_definition = aws_ecs_task_definition.server.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = var.alb_ecs_prod_tg
    container_name   = var.prod_container_name
    container_port   = 3000
  }

  load_balancer {
    target_group_arn = var.alb_ecs_stage_tg
    container_name   = var.stage_container_name
    container_port   = 3001
  }
}

