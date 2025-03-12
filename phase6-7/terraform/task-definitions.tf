data "aws_ecr_image" "service_image" {
  repository_name = module.ecr.repository_name
  most_recent     = true
}

###################
# Task definitions
###################

// app
resource "aws_ecs_task_definition" "app-task" {
  family                   = "${var.project}-${var.env}-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.project}-${var.env}-app",
      image = "${module.ecr.repository_url}:latest",

      essential = true,
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "app",
          awslogs-region        = "us-east-1",
          awslogs-create-group  = "true",
          awslogs-stream-prefix = "app"
        }
      },
      environment = [
        {
          name  = "APP_DB_USER",
          value = "nodeapp"
        },
        {
          name  = "APP_DB_PASSWORD",
          value = module.aurora_mysql.cluster_master_user_secret
        },
        {
          name  = "APP_DB_HOST",
          value = module.aurora_mysql.cluster_endpoint
        },
        {
          name  = "APP_DB_NAME",
          value = "STUDENTS"
        }
      ],
      secrets = [
      ],
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        }
      ]
    }
  ])
  /* lifecycle {
    ignore_changes = [container_definitions.image] // let AutoDevops pipeline update the image task
  } */
}
