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

##################
# Instance Profile
##################
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = data.aws_iam_role.labrole.name
}

##################
# Instance phase1
##################
module "web_sg" {
  source              = "terraform-aws-modules/security-group/aws//modules/web"
  version             = "5.3.0"
  vpc_id              = module.vpc.vpc_id
  name                = "web-sg"
  description         = "Security group for web access"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  tags = {
    Name      = "web1-sg"
    Terraform = "true"
  }
}

module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 5.0"
  name                        = "webserver-p1"
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  key_name                    = module.key_pair.key_pair_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.web_sg.security_group_id, module.bdd_sg.security_group_id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              cd /home/ubuntu
              curl -o UserdataScript-phase-2.sh https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACCAP1-1-91571/1-lab-capstone-project-1/s3/UserdataScript-phase-2.sh
              chmod +x UserdataScript-phase-2.sh
              ./UserdataScript-phase-2.sh
              EOF
}
