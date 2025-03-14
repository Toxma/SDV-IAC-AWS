provider "aws" {
  region     = local.region
  access_key = ""
  secret_key = ""
  token      = ""
}
locals {
  name     = "nodeapp-dev"
  region   = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Example = local.name
  }
}
