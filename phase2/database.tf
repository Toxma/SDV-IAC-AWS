module "db" {
  source               = "terraform-aws-modules/rds/aws"
  identifier           = "myrds"
  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0"
  major_engine_version = "8.0"

  instance_class        = "db.t3.micro"
  allocated_storage     = 10
  max_allocated_storage = 20

  db_name                     = "STUDENTS"
  username                    = "nodeapp"
  password                    = "student12"
  manage_master_user_password = false

  port                   = "3306"
  multi_az               = true
  db_subnet_group_name   = module.vpc.database_subnet_group
  storage_encrypted      = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [module.bdd_sg.security_group_id]

  tags = {
    Name      = "database"
    Terraform = "true"
  }
}
