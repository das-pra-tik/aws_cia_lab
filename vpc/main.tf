# Create non-default VPC for Lamp-Stack App
resource "aws_vpc" "lamp-app-vpc" {
  cidr_block           = lookup(var.vpc-map, "lamp-app-vpc")
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "lamp-app-vpc"
  }
}

# Create non-default Internet Gateway
resource "aws_internet_gateway" "lamp-app-igw" {
  depends_on = [aws_vpc.lamp-app-vpc]
  vpc_id     = aws_vpc.lamp-app-vpc.id
  tags = {
    Name = "lamp-app-IGW"
  }
}

resource "aws_subnet" "lamp-app-public" {
  depends_on              = [aws_vpc.lamp-app-vpc]
  for_each                = var.lamp-app-subnets
  vpc_id                  = aws_vpc.lamp-app-vpc.id
  cidr_block              = each.value.lamp-app-public
  availability_zone       = each.value.lamp-app-az
  map_public_ip_on_launch = true
  tags = {
    Name = "lamp-app-PublicSubnet"
    Tier = "lamp-app-Public"
  }
}

resource "aws_subnet" "lamp-app-private" {
  depends_on              = [aws_vpc.lamp-app-vpc]
  for_each                = var.lamp-app-subnets
  vpc_id                  = aws_vpc.lamp-app-vpc.id
  cidr_block              = each.value.lamp-app-private
  availability_zone       = each.value.lamp-app-az
  map_public_ip_on_launch = false
  tags = {
    Name = "lamp-app-PrivateSubnet"
    Tier = "lamp-app-Private"
  }
}

resource "aws_route_table" "lamp-app-public-rt" {
  depends_on = [aws_subnet.lamp-app-public]
  vpc_id     = aws_vpc.lamp-app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lamp-app-igw.id
  }
  tags = {
    Name = "lamp-app-PublicRT"
  }
}

resource "aws_route_table_association" "lamp-app-public-rt-assoc" {
  depends_on     = [aws_subnet.lamp-app-public, aws_route_table.lamp-app-public-rt]
  for_each       = var.lamp-app-subnets
  subnet_id      = aws_subnet.lamp-app-public[each.key].id
  route_table_id = aws_route_table.lamp-app-public-rt.id
}

resource "aws_route_table" "lamp-app-private-rt" {
  depends_on = [aws_subnet.lamp-app-private, var.tgw-id]
  vpc_id     = aws_vpc.lamp-app-vpc.id

  route {
    cidr_block         = var.shared-vpc-cidr
    transit_gateway_id = var.tgw-id
  }

  tags = {
    Name = "lamp-app-PrivateRT"
  }
}

resource "aws_route_table_association" "private-rt-association" {
  depends_on     = [aws_subnet.lamp-app-private, aws_route_table.lamp-app-private-rt]
  for_each       = var.lamp-app-subnets
  subnet_id      = aws_subnet.lamp-app-private[each.key].id
  route_table_id = aws_route_table.lamp-app-private-rt.id
}

# ------------------------------------------------------------------------------
# Create non-default VPC for Lamp-Stack App
resource "aws_vpc" "shared-vpc" {
  cidr_block           = lookup(var.vpc-map, "shared-vpc")
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "shared-vpc"
  }
}

# Create non-default Internet Gateway
resource "aws_internet_gateway" "shared-vpc-igw" {
  depends_on = [aws_vpc.shared-vpc]
  vpc_id     = aws_vpc.shared-vpc.id
  tags = {
    Name = "shared-vpc-IGW"
  }
}

resource "aws_subnet" "shared-vpc-public" {
  depends_on              = [aws_vpc.shared-vpc]
  for_each                = var.shared-vpc-subnets
  vpc_id                  = aws_vpc.shared-vpc.id
  cidr_block              = each.value.shared-vpc-public
  availability_zone       = each.value.shared-vpc-az
  map_public_ip_on_launch = true
  tags = {
    Name = "shared-vpc-PublicSubnet"
    Tier = "shared-vpc-Public"
  }
}

resource "aws_subnet" "shared-vpc-private" {
  depends_on              = [aws_vpc.shared-vpc]
  for_each                = var.shared-vpc-subnets
  vpc_id                  = aws_vpc.shared-vpc.id
  cidr_block              = each.value.shared-vpc-private
  availability_zone       = each.value.shared-vpc-az
  map_public_ip_on_launch = false
  tags = {
    Name = "shared-vpc-PrivateSubnet"
    Tier = "shared-vpc-Private"
  }
}

resource "aws_route_table" "shared-vpc-public-rt" {
  depends_on = [aws_subnet.shared-vpc-public]
  vpc_id     = aws_vpc.shared-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shared-vpc-igw.id
  }
  tags = {
    Name = "shared-vpc-PublicRT"
  }
}

resource "aws_route_table_association" "shared-vpc-public-rt-assoc" {
  depends_on     = [aws_subnet.shared-vpc-public, aws_route_table.shared-vpc-public-rt]
  for_each       = var.shared-vpc-subnets
  subnet_id      = aws_subnet.shared-vpc-public[each.key].id
  route_table_id = aws_route_table.shared-vpc-public-rt.id
}

resource "aws_route_table" "shared-vpc-private-rt" {
  depends_on = [aws_subnet.shared-vpc-private, var.tgw-id]
  vpc_id     = aws_vpc.shared-vpc.id

  route {
    cidr_block         = var.lamp-app-vpc-cidr
    transit_gateway_id = var.tgw-id
  }

  tags = {
    Name = "shared-vpc-PrivateRT"
  }
}

resource "aws_route_table_association" "shared-vpc-private-rt-assoc" {
  depends_on     = [aws_subnet.shared-vpc-private, aws_route_table.shared-vpc-private-rt]
  for_each       = var.shared-vpc-subnets
  subnet_id      = aws_subnet.shared-vpc-private[each.key].id
  route_table_id = aws_route_table.shared-vpc-private-rt.id
}
