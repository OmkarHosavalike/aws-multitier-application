resource "aws_db_subnet_group" "db_subnets" {
  name = "${var.project}-${var.env}-db-subnet-group"
  subnet_ids = [ for s in aws_subnet.db_private : s.id] #values(aws_subnet.db_private)

  tags = {
    Name        = "${var.project}-${var.env}-db-subnet-group"
    Project     = var.project
    Environment = var.env
  }  
}

resource "aws_db_instance" "mysql" {
  identifier = "${var.project}-${var.env}-mysql"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [ aws_security_group.db.id ]
  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name        = "${var.project}-${var.env}-mysql"
    Project     = var.project
    Environment = var.env    
  }
}