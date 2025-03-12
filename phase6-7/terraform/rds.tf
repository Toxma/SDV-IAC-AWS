################################
# Postregresql Aurora Cluster 
################################
resource "random_password" "aurora_mysql_master_password" {
  length           = 16
  special          = false
}

resource "aws_kms_key" "aurora_kms_key" {
  description             = "CMK for Aurora MariaDB server side encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = false
}

resource "aws_kms_alias" "aurora_kms_key_alias" {
  name          = "alias/aurora-data-store-key"
  target_key_id = aws_kms_key.aurora_kms_key.id
}

module "aurora_mysql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.3.1"

  name          = join("-", [var.project, var.env, "aurora-mysql"])
  database_name = var.db_name

  engine         = "aurora-mysql"
  engine_version = "8.0"

  instance_class = "db.t3.medium"

  instances = {
    one = {}
  }
  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 2
  }

  master_username             = "root"
  manage_master_user_password = true

  storage_encrypted = true
  kms_key_id        = aws_kms_key.aurora_kms_key.arn

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name

  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = [module.vpc.vpc_cidr_block]
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
    }
  }

  apply_immediately   = true
  skip_final_snapshot = true

  deletion_protection = false
}

