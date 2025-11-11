resource "aws_security_group" "bastion" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project}-${var.env}-bastion-sg"
  description = "Bastion for admin access"

  tags = {
    Name = "${var.project}-${var.env}-bastion-sg"
  }
}

resource "aws_security_group_rule" "bastion_ssh_in" {
  security_group_id = aws_security_group.bastion.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.my_ip_cidr]
}

resource "aws_security_group_rule" "bastion_all_out" {
  security_group_id = aws_security_group.bastion.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "frontend" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project}-${var.env}-frontend-sg"
  description = "Frontend web servers"

  tags = {
    Name = "${var.project}-${var.env}-frontend-sg"
  }
}

resource "aws_security_group_rule" "frontend_http" {
  security_group_id = aws_security_group.frontend.id
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
}

resource "aws_security_group_rule" "frontend_https" {
  security_group_id = aws_security_group.frontend.id
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
}

resource "aws_security_group_rule" "frontend_ssh_from_bastion" {
  security_group_id        = aws_security_group.frontend.id
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "control_node_ssh_in" {
  security_group_id = aws_security_group.frontend.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.my_ip_cidr]
}

resource "aws_security_group_rule" "frontend_all_out" {
  security_group_id = aws_security_group.frontend.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group" "backend" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project}-${var.env}-backend-sg"
  description = "Backend application servers"

  tags = {
    Name = "${var.project}-${var.env}-backend-sg"
  }
}

resource "aws_security_group_rule" "backend_app_from_frontend" {
  security_group_id        = aws_security_group.backend.id
  protocol                 = "tcp"
  from_port                = 8080
  to_port                  = 8080
  source_security_group_id = aws_security_group.frontend.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "backend_ssh_from_bastion" {
  security_group_id        = aws_security_group.backend.id
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "backend_all_out" {
  security_group_id = aws_security_group.backend.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group" "db" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.project}-${var.env}-db-sg"
  description = "Database security group"

  tags = {
    Name = "${var.project}-${var.env}-db-sg"
  }
}

resource "aws_security_group_rule" "db_from_backend" {
  security_group_id        = aws_security_group.db.id
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.backend.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "db_all_out" {
  security_group_id = aws_security_group.db.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}
