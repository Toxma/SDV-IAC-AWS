module "webserver1" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 5.0"
  name                        = "webserver1"
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  key_name                    = "vockey"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.web1_sg.security_group_id, module.mysql_sg.security_group_id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              cd /home/ubuntu
              curl -o UserdataScript-phase-2.sh https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACCAP1-1-91571/1-lab-capstone-project-1/s3/UserdataScript-phase-2.sh
              chmod +x UserdataScript-phase-2.sh
              ./UserdataScript-phase-2.sh
              EOF
  tags = {
    Name      = "webserver1"
    Terraform = "true"
  }
}

module "webserver2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 5.0"
  name                        = "webserver2"
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  key_name                    = "vockey"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.web2_sg.security_group_id]
  iam_instance_profile        = aws_iam_instance_profile.ecs_instance_profile.name
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash -xe
              apt update -y
              apt install nodejs unzip wget npm mysql-client -y
              #wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACCAP1-1-DEV/code.zip -P /home/ubuntu
              wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACCAP1-1-91571/1-lab-capstone-project-1/code.zip -P /home/ubuntu
              cd /home/ubuntu
              unzip code.zip -x "resources/codebase_partner/node_modules/*"
              cd resources/codebase_partner
              npm install aws aws-sdk
              export APP_PORT=80
              npm start &
              echo '#!/bin/bash -xe
              cd /home/ubuntu/resources/codebase_partner
              export APP_PORT=80
              npm start' > /etc/rc.local
              chmod +x /etc/rc.local
              EOF
  tags = {
    Name      = "webserver2"
    Terraform = "true"
  }
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = data.aws_iam_role.labrole.name
}
