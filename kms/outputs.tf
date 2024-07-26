output "kms-key-id" {
  value = aws_kms_key.cia_lab_kms_key.key_id
}
output "kms-key-arn" {
  value = aws_kms_key.cia_lab_kms_key.arn
}
