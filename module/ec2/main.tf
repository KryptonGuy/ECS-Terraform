# EC2 Launch Template
resource "aws_launch_template" "app" {
  name        = var.ec2_launch_template_name
  description = "EC2 Launch Template for ECS Cluster"


  credit_specification {
    cpu_credits = "standard"
  }


  iam_instance_profile {
    arn = var.ec2_role_arn
  }

  image_id = var.ec2_ami_id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.ec2_instance_type


  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.ec2_security_group
  }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config;
    EOF
  )

}

# MongoDB EC2 Instance

resource "random_id" "index" {
  byte_length = 2
}

locals {
  subnet_ids_list = tolist(var.private_subnets)

  subnet_ids_random_index = random_id.index.dec % length(var.private_subnets)

  instance_subnet_id = local.subnet_ids_list[local.subnet_ids_random_index]
}


resource "aws_instance" "db" {
  ami                         = var.db_ami_id
  instance_type               = var.db_instance_type
  subnet_id                   = local.instance_subnet_id
  key_name                    = var.db_key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = var.db_security_groups


  tags = {
    Name = "prod-mongo-db-instance"
  }

  lifecycle {
    create_before_destroy = true
  }
}
