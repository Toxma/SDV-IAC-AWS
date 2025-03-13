module "bdd_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.3.0"
  vpc_id      = module.vpc.vpc_id
  name        = "bdd-sg"
  description = "Complete MySQL security group"
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from public subnet"
      cidr_blocks = "10.0.1.0/24"
    },
  ]
  tags = {
    Name      = "bdd-sg"
    Terraform = "true"
  }
}

module "db" {
  source                      = "terraform-aws-modules/rds/aws"
  identifier                  = "myrds"
  engine                      = "mysql"
  engine_version              = "8.0"
  family                      = "mysql8.0"
  major_engine_version        = "8.0"
  instance_class              = "db.t3.micro"
  allocated_storage           = 10
  max_allocated_storage       = 20
  db_name                     = "STUDENTS"
  username                    = "nodeapp"
  password                    = "student12"
  manage_master_user_password = false
  port                        = "3306"
  multi_az                    = true
  db_subnet_group_name        = module.vpc.database_subnet_group
  storage_encrypted           = false
  skip_final_snapshot         = true
  vpc_security_group_ids      = [module.bdd_sg.security_group_id]
  tags = {
    Name      = "database"
    Terraform = "true"
  }
}
