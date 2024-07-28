output "instance-ids" {
  value = [for x in aws_instance.target_nodes : x.id]
}
output "ami-id" {
  value = data.aws_ami.amzn_ami.image_id
}
output "instance-size" {
  value = var.instance_type
}
