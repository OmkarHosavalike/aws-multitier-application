resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project}-${var.env}-vpc"
    Project     = var.project
    Environment = var.env
  }

}

locals {
  azs               = var.availability_zones
  public_subnet_map = zipmap(local.azs, var.public_subnets)
  app_subnet_map    = zipmap(local.azs, var.private_app_subnets)
  db_subnet_map     = zipmap(local.azs, var.private_db_subnets)
  my_ip_cidr        = "${chomp(data.http.myip.response_body)}/32"
}

resource "aws_subnet" "public" {
  for_each                = local.public_subnet_map
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.env}-public-${each.key}"
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_subnet" "app_private" {
  for_each                = local.app_subnet_map
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-${var.env}-app-private-${each.key}"
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_subnet" "db_private" {
  for_each                = local.db_subnet_map
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-${var.env}-db-private-${each.key}"
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-${var.env}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project}-${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = values(aws_subnet.app_private)[0].id
  route_table_id = aws_route_table.private.id
}
