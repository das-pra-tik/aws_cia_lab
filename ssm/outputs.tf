/*
output "ssm-param-name" {
  # value = aws_ssm_parameter.cia_lab_secret.name
  value = [for v in var.parameters : v.key]
}
output "ssm-param-value" {
  # value = aws_ssm_parameter.cia_lab_secret.value
  value = [for v in var.parameters : v.value]
}
*/
output "ssm_value" {
  //value = aws_ssm_parameter.cia_lab_secret.value
  value = random_password.random_secrets.result
}
