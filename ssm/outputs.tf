output "ssm-param-name" {
  value = aws_ssm_parameter.cia_lab_secret.name
}

output "ssm-param-value" {
  value = aws_ssm_parameter.cia_lab_secret.value
}
