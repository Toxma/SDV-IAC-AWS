module "web_sg" {
  source              = "terraform-aws-modules/security-group/aws//modules/web"
  version             = "5.3.0"
  vpc_id              = module.vpc.vpc_id
  name                = "web-sg"
  description         = "Security group for web access"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Access to Mysql DB"
      cidr_blocks = "10.0.3.0/24"
    }
  ]
  tags = {
    Name      = "web-sg"
    Terraform = "true"
  }
}

module "bdd_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.3.0"
  vpc_id      = module.vpc.vpc_id
  name        = "bdd-sg"
  description = "Complete MySQL example security group"
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
