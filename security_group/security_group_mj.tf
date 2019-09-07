variable "name" {}
variable "vpc_id" {}
variable "port" {}

variable "cidr_blocks" {
  type = list(string)
}

resource "aws_security_group" "default" {
  name   = var.name
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
  security_group_id = aws_security_group.default.id
}

output "aws_security_group_id" {
  value = aws_security_group.default.id
}
