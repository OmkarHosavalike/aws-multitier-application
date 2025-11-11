resource "aws_instance" "bastion" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = values(aws_subnet.public)[0].id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "${var.project}-${var.env}-bastion"
    Project     = var.project
    Environment = var.env    
  }
}

resource "aws_instance" "frontend" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = values(aws_subnet.public)[0].id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.frontend.id]
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "${var.project}-${var.env}-frontend"
    Project     = var.project
    Environment = var.env    
  }
}

resource "aws_instance" "backend" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer.key_name
  subnet_id = values(aws_subnet.app_private)[0].id
  vpc_security_group_ids = [ aws_security_group.backend.id ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = false

  tags = {
    Name = "${var.project}-${var.env}-backend"
    Project     = var.project
    Environment = var.env    
  }
}