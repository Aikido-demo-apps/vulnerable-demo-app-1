resource "aws_alb" "main" {
  name            = "demo-load-balancer"
  subnets         = [for subnet in aws_subnet.public: "${subnet.id}"]
  security_groups = [aws_security_group.external.id]
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
  port              = 3000
  protocol          = "HTTP"
  
  default_action {
    target_group_arn = "${aws_alb_target_group.api.arn}"
    type             = "forward"
  }
}