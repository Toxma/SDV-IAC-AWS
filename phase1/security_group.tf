module "security_group_web" {
  source              = "terraform-aws-modules/security-group/aws//modules/web"
  version             = "5.3.0"
  vpc_id              = module.vpc.vpc_id
  name                = "web-sg"
  description         = "Security group for web access"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  tags = {
    Name      = "web-sg"
    Terraform = "true"
  }
}
