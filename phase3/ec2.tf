##################
# Security groups
##################
resource "aws_security_group" "service_security_group" {
  name   = "${local.name}-web-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# module "webserver1" {
#   source                      = "terraform-aws-modules/ec2-instance/aws"
#   version                     = "~> 5.0"
#   ami                         = "ami-0e1bed4f06a3b463d"
#   instance_type               = "t2.micro"
#   key_name                    = module.key_pair.key_pair_name
#   subnet_id                   = module.vpc.public_subnets[0]
#   vpc_security_group_ids      = [aws_security_group.service_security_group.id]
#   associate_public_ip_address = true
#   user_data                   = file("${path.cwd}/user-data.sh")
#   tags = {
#     Name        = "Web1"
#     Terraform   = "true"
#     Environment = "Test"
#   }
# }

# module "webserver2" {
#   source                      = "terraform-aws-modules/ec2-instance/aws"
#   version                     = "~> 5.0"
#   ami                         = "ami-0e1bed4f06a3b463d"
#   instance_type               = "t2.micro"
#   key_name                    = module.key_pair.key_pair_name
#   subnet_id                   = module.vpc.public_subnets[1]
#   vpc_security_group_ids      = [aws_security_group.service_security_group.id]
#   associate_public_ip_address = true
#   user_data                   = file("${path.cwd}/user-data.sh")
#   tags = {
#     Name        = "Web2"
#     Terraform   = "true"
#     Environment = "Test"
#   }
# }
