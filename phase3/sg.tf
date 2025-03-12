module "web_sg" {
  source              = "terraform-aws-modules/security-group/aws//modules/web"
  version             = "~> 5.3"
  vpc_id              = module.vpc.vpc_id
  name                = "${local.name}-web"
  description         = "Security group for web access"
  ingress_cidr_blocks = ["10.0.0.0/16"]
  tags = {
    Terraform   = "true"
    Environment = "Dev"
  }
}

