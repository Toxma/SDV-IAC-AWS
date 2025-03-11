module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 5.0"
  name                        = "webserver"
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  key_name                    = "vockey"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.security_group_web.security_group_id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              cd /home/ubuntu
              curl -o UserdataScript-phase-2.sh https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACCAP1-1-91571/1-lab-capstone-project-1/s3/UserdataScript-phase-2.sh
              chmod +x UserdataScript-phase-2.sh
              ./UserdataScript-phase-2.sh
              EOF
  tags = {
    Name      = "webserver"
    Terraform = "true"
  }
}
