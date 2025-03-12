module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs              = local.azs
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}
