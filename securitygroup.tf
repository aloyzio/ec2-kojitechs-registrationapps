#sg for load balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "allow http"
  vpc_id      = local.vpc_id

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#security group for app_1 and app_2
resource "aws_security_group" "front_app_sg" {
  name        = "front_app_sg"
  description = "allow http"
  vpc_id      = local.vpc_id

  ingress {
    description     = "allow http"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }
  ingress {
    description     = "allow http"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "front_app"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "registration_app" {
  name        = "registration_app"
  description = "allow http"
  vpc_id      = local.vpc_id
  ingress {
    description     = "allow from load_balancer"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "registration_app"
  }
  lifecycle {
    create_before_destroy = true
  }
}