output "db-sg-ids" {
  value = aws_security_group.rds_sg.id
}
output "ec2-sg-ids" {
  value = aws_security_group.ec2_sg.id
}
output "alb-sg-ids" {
  value = aws_security_group.alb_sg.id
}
output "rds-sg-name" {
  value = aws_security_group.rds_sg.name
}
output "ec2-sg-name" {
  value = aws_security_group.ec2_sg.name
}
output "alb-sg-name" {
  value = aws_security_group.alb_sg.name
}
