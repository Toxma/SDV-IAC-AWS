################################
# MySQL RDS Cluster
################################
module "aurora_mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.10.0"

  identifier = join("-", [var.project, var.env, "mysql"])

  username = "root"
  db_name  = "students"

  allocated_storage = 5

  engine         = "mysql"
  engine_version = "8.0"

  major_engine_version = "8.0"
  family               = "mysql8.0"

  instance_class = "db.t3.small"

  manage_master_user_password = true

  vpc_security_group_ids = [
    aws_security_group.ecs_access_sg.id
  ]

  db_subnet_group_name = module.vpc.database_subnet_group_name

  apply_immediately   = true
  skip_final_snapshot = true

  deletion_protection = false
}

resource "aws_security_group" "ecs_access_sg" {
  name        = "${var.project}-${var.env}-ecs-access-sg"
  description = "Security group to allow ECS access to RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.service_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


