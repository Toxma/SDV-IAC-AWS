##################
# Launch template
##################
resource "aws_launch_template" "web" {
  name = "web"
  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 20
    }
  }
  image_id                             = "ami-0e1bed4f06a3b463d"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = module.vpc.public_subnets[0]
    security_groups             = [aws_security_group.service_security_group.id]
  }
  placement {
    availability_zone = "us-east-1a"
  }
  user_data = filebase64("${path.cwd}/user-data.sh")
}

resource "aws_autoscaling_group" "asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1
  target_group_arns  = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}
