##################
# Security Groups
##################

resource "aws_security_group" "service_security_group" {
  name   = "${var.project}-${var.env}-ecs-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################
# ECS Cluster
##################

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.project}-${var.env}-ecs"
}

##################
# ECS Services
##################

// app Service
resource "aws_ecs_service" "app-service" {
  name            = "${var.project}-${var.env}-app"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.app-task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "${var.project}-${var.env}-app"
    container_port   = 80
  }

  network_configuration {
    subnets          = tolist(module.vpc.private_subnets)
    assign_public_ip = false
    security_groups  = [aws_security_group.service_security_group.id]
  }
}

// Scaling policies

resource "aws_appautoscaling_target" "dev_to_target" {
  max_capacity       = 1
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster.name}/${aws_ecs_service.app-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "dev_to_cpu" {
  name               = "dev-to-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dev_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dev_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dev_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}

