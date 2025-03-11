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
      name = "${var.project}-${var.env}-app",
      image : "${module.ecr.repository_url}:${data.aws_ecr_image.service_image.image_digest}",
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

/*
Has to be filled in manually by user once infrastructure is applied :
{
"username": "gitlab-ci-token",
"password": "your_personal_access_token_here"
}
*/

resource "aws_secretsmanager_secret" "mydbsecret" {
  name = "mydbsecret"
}

resource "aws_secretsmanager_secret_version" "mydbsecret" {
  secret_id = aws_secretsmanager_secret.mydbsecret.id
  secret_string = jsonencode({
    user     = "nodeapp"
    password = "student12"
    host     = "db"
    db       = "STUDENTS"
  })
}

