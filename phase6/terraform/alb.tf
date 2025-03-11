##################
# Security groups
##################
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.env}-lb-sg"
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
  name               = "${var.project}-${var.env}-alb"
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
  name        = "${var.project}-${var.env}-tg-wp"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  health_check {
    protocol = "HTTP"
    matcher  = "200"
    port     = 80
    path     = "/index.php"

  }
}
