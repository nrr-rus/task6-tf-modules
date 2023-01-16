resource "aws_security_group" "AWS-TR-SG" {
  tags = {
    Name = "AWS-TR-SG"
  }

   dynamic "ingress" {
     for_each = ["22", "80", "8080"]
     content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.value
      protocol    = "tcp"
      to_port     = ingress.value
     }
   }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  name   = "AWS-TR-Security-group"
  vpc_id = var.vpc_bind
}