# Data Block
data "aws_availability_zones" "available_azs" { state = "available" }
/*
data "aws_vpc" "instance_vpc" { id = var.vpc-id }
data "aws_subnets" "ec2_subnets" {
  depends_on = [data.aws_vpc.instance_vpc]
  filter {
    name   = "vpc-id"
    values = [var.vpc-id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = [false]
  }
}
*/
data "aws_ami" "amzn_ami" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "target_nodes" {
  depends_on             = [aws_key_pair.ssh_key_pair]
  count                  = length(var.ec2_subnet_ids)
  ami                    = data.aws_ami.amzn_ami.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = var.instance_sec_grp_ids
  subnet_id              = element(var.ec2_subnet_ids, count.index)
  //subnet_id                   = element(tolist(data.aws_subnets.ec2_public_subnets.ids), count.index)
  associate_public_ip_address = false
  disable_api_termination     = false
  user_data                   = file(var.USER_DATA)
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  monitoring                  = true
  source_dest_check           = true
  lifecycle {
    ignore_changes = [tags["Create_date_time"], ami]
  }
  timeouts {
    create = "10m"
  }

  # root disk
  root_block_device {
    volume_size           = var.root_vol_size
    volume_type           = var.root_vol_type
    delete_on_termination = "true"
    encrypted             = "true"
    kms_key_id            = var.kms_key_id
  }
}

# Create EBS Data volumes
resource "aws_ebs_volume" "ebs-vol01" {
  depends_on        = [aws_instance.target_nodes]
  count             = length(var.ec2_subnet_ids)
  availability_zone = data.aws_availability_zones.available_azs.names[count.index]
  size              = 15
  type              = "gp3"
  encrypted         = "true"
  kms_key_id        = var.kms_key_id
  final_snapshot    = false
}

resource "aws_ebs_volume" "ebs-vol02" {
  depends_on        = [aws_instance.target_nodes]
  count             = length(var.ec2_subnet_ids)
  availability_zone = data.aws_availability_zones.available_azs.names[count.index]
  size              = 10
  type              = "gp3"
  encrypted         = "true"
  kms_key_id        = var.kms_key_id
  final_snapshot    = false
}

# Attach EBS Volumes to EC2 instances we created earlier
resource "aws_volume_attachment" "ebs-vol01-attachment" {
  depends_on   = [aws_instance.target_nodes, aws_ebs_volume.ebs-vol01]
  count        = length(var.ec2_subnet_ids)
  device_name  = "/dev/xvdh"
  instance_id  = aws_instance.target_nodes.*.id[count.index]
  volume_id    = aws_ebs_volume.ebs-vol01.*.id[count.index]
  force_detach = "true"
  skip_destroy = "false"
}

resource "aws_volume_attachment" "ebs-vol02-attachment" {
  depends_on   = [aws_instance.target_nodes, aws_ebs_volume.ebs-vol02]
  count        = length(var.ec2_subnet_ids)
  device_name  = "/dev/xvdj"
  instance_id  = aws_instance.target_nodes.*.id[count.index]
  volume_id    = aws_ebs_volume.ebs-vol02.*.id[count.index]
  force_detach = "true"
  skip_destroy = "false"
}
