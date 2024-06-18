

# Application Load Balancer
resource "aws_lb" "server" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.server-lb-sg]
  subnets            = var.public_subnets
}

# ALB Target Group for production
resource "aws_lb_target_group" "server_tg" {
  name        = "${var.tg_name}-prod-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/health"
    timeout             = 60
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

}

# ALB Target Group for Stage env
resource "aws_lb_target_group" "stage-tg" {
  name        = "${var.tg_name}-stage-tg"
  port        = 3001
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/health"
    timeout             = 60
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
}

# ALB Target Group for Dev Env
resource "aws_lb_target_group" "dev-tg" {
  name        = "${var.tg_name}-dev-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/health"
    timeout             = 60
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
}

# HTTP Listener Redirect to HTTPS
resource "aws_lb_listener" "server_http" {
  load_balancer_arn = aws_lb.server.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener
resource "aws_lb_listener" "server_https" {
  load_balancer_arn = aws_lb.server.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.ssl_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server_tg.arn
  }
}

# HTTPS listener rule for prod
resource "aws_lb_listener_rule" "prod" {
  listener_arn = aws_lb_listener.server_https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server_tg.arn
  }

  condition {
    host_header {
      values = []
    }
  }
}


# HTTPS listener rule for stage
resource "aws_lb_listener_rule" "stage" {
  listener_arn = aws_lb_listener.server_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stage-tg.arn
  }

  condition {
    host_header {
      values = []
    }
  }
}

# HTTPS listener rule for dev
resource "aws_lb_listener_rule" "dev" {
  listener_arn = aws_lb_listener.server_https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-tg.arn
  }

  condition {
    host_header {
      values = []
    }
  }
}