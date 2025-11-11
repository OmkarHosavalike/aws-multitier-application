output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "app_private_subnet_ids" {
  value = [for s in aws_subnet.app_private : s.id]
}

output "db_private_subnet_ids" {
  value = [for s in aws_subnet.db_private : s.id]
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "frontend_sg_id" {
  value = aws_security_group.frontend.id
}

output "backend_sg_id" {
  value = aws_security_group.backend.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_assets.bucket
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "ec2_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "db_port" {
  value = aws_db_instance.mysql.port
}

output "key_pair_private_key" {
  value       = tls_private_key.key.private_key_pem
  sensitive   = true
  description = "Private key for accessing the EC2 instance"
}

output "backend_private_ip" {
  value = aws_instance.backend.private_ip
}

output "backend_id" {
  value = aws_instance.backend.id  
}