output "ssm_value" {
  //value = aws_ssm_parameter.cia_lab_secret.value
  value = random_password.random_secrets.result
}
