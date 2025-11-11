variable "aws_region" {
  default = "us-east-1"
}

variable "project" {
  default = "multi-tier-app"
}

variable "env" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnets" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_db_subnets" {
  type    = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "my_ip_cidr" {
  type = string
}

variable "s3_bucket_name" {
  type        = string
  description = "Globally unique bucket name to be set in terraform.tfvars file"
  validation {
    condition     = var.s3_bucket_name != ""
    error_message = "Set a non-empty bucket name in tfvars"
  }
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ami_id" {
  default = "ami-0cae6d6fe6048ca2c"
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "db_name" {
  default = "mydb"
}

variable "db_username" {
  default = "dbuser"
}

variable "db_password" {
  default = "Passw0rd123!"
  sensitive = true
}

variable "db_allocated_storage" {
  default = 20
}
