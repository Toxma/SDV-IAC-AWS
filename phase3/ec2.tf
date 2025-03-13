##################
# Security groups
##################
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

module "webserver1" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 5.0"
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  key_name                    = module.key_pair.key_pair_name
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [module.web_sg.security_group_id]
  associate_public_ip_address = false
  user_data                   = file("${path.cwd}/user-data.sh")
  tags = {
    Name        = "Web1"
    Terraform   = "true"
    Environment = "Test"
  }
}

module "webserver2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 5.0"
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  key_name                    = module.key_pair.key_pair_name
  subnet_id                   = module.vpc.private_subnets[1]
  vpc_security_group_ids      = [module.web_sg.security_group_id]
  associate_public_ip_address = false
  user_data                   = file("${path.cwd}/user-data.sh")
  tags = {
    Name        = "Web2"
    Terraform   = "true"
    Environment = "Test"
  }
}
