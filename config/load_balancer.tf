resource "aws_alb" "main" {
  name                       = "demo-load-balancer"
  subnets                    = [for subnet in aws_subnet.public: "${subnet.id}"]
  security_groups            = [aws_security_group.external.id]
  drop_invalid_header_fields = true
}

resource "aws_alb_target_group" "api" {
  name        = "demo-load-balancer"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTPS"
    matcher             = "200"
    healthy_threshold   = 3
    interval            = 30
    timeout             = 3
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "frontend" {
  load_balancer_arn = aws_alb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:eu-west-1:123456789:certificate/b6415e7e-6fba-4d86-8ba6-f86e32ecbd58"
  
  default_action {
    target_group_arn = "${aws_alb_target_group.api.arn}"
    type             = "forward"
  }
}