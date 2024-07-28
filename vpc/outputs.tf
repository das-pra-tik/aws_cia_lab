output "lamp-app-vpc-id" {
  value = aws_vpc.lamp-app-vpc.id
}

output "shared-vpc-id" {
  value = aws_vpc.shared-vpc.id
}

output "lamp-app-vpc-cidr" {
  value = aws_vpc.lamp-app-vpc.cidr_block
}

output "shared-vpc-cidr" {
  value = aws_vpc.shared-vpc.cidr_block
}

output "shared-vpc-private-subnet-ids" {
  value = [for s in aws_subnet.shared-vpc-private : s.id]
}

output "lamp-app-vpc-private-subnet-ids" {
  value = [for s in aws_subnet.lamp-app-private : s.id]
}

output "lamp-app-vpc-public-subnet-ids" {
  value = [for s in aws_subnet.lamp-app-public : s.id]
}

output "lamp-app-vpc-database-subnet-ids" {
  value = [for s in aws_subnet.lamp-app-database : s.id]
}
/*
output "shared-vpc-private-subnet-cidrs" {
  value = [for s in aws_subnet.shared-vpc-private : s.cidr_block]
}

output "lamp-app-vpc-public-subnet-ids" {
  value = aws_subnet.lamp-app-public.*.id
}

output "shared-vpc-public-subnet-ids" {
  value = aws_subnet.shared-vpc-public[*].id
}

output "shared-vpc-private-subnet-ids" {
  value = aws_subnet.shared-vpc-private[*].id
}

output "lamp-app-vpc-private-subnet-ids" {
  value = aws_subnet.lamp-app-private.*.id
}
*/

