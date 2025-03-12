##################
# VPC
##################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.1"

  name = "${var.project}-${var.env}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subs
  public_subnets  = var.public_subs

  database_subnets   = var.database_subs
  enable_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true
}