##################
# Security groups
##################
resource "aws_security_group" "alb_sg" {
  name        = "${local.name}-lb-sg"
  description = "Allow incoming traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################
# ALB
##################
resource "aws_lb" "alb" {
  name               = "${local.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

// app listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group" "app_tg" {
  name        = "${local.name}-tg-wp"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  health_check {
    protocol = "HTTP"
    matcher  = "200"
    port     = 80
    path     = "/"
    interval = 30
    timeout  = 5
  }
}

# resource "aws_lb_target_group_attachment" "app_attachment_web1" {
#   target_group_arn = aws_lb_target_group.app_tg.arn
#   target_id        = module.webserver1.id
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "app_attachment_web2" {
#   target_group_arn = aws_lb_target_group.app_tg.arn
#   target_id        = module.webserver2.id
#   port             = 80
# }

resource "aws_autoscaling_attachment" "app_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.app_tg.arn
}
