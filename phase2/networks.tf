module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets   = ["10.0.1.0/24"]
  private_subnets  = ["10.0.2.0/24"]
  database_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  enable_nat_gateway                 = true
  single_nat_gateway                 = true
  enable_dns_hostnames               = true
  enable_dns_support                 = true

  public_subnet_tags = {
    Name = "VPC Public Subnets"
  }

  private_subnet_tags = {
    Name = "VPC Private Subnets"
  }

  database_subnet_tags = {
    Name = "VPC Private Database Subnets"
  }

  map_public_ip_on_launch = true

  tags = {
    Name      = "my-vpc"
    Terraform = "true"
  }
}
