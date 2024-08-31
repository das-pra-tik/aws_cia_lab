# Data Block
data "aws_availability_zones" "available_azs" { state = "available" }

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
/*
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
*/

# ASG with Launch template
resource "aws_launch_template" "ec2_launch_templ" {
  name                    = var.lt_name
  image_id                = data.aws_ami.amzn_ami.id #specific for each region
  instance_type           = var.instance_type
  user_data               = filebase64(var.USER_DATA)
  ebs_optimized           = false
  key_name                = var.key_pair_name
  disable_api_termination = false
  update_default_version  = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.instance_sec_grp_ids
    delete_on_termination       = true
  }
  block_device_mappings {
    # Root volume
    device_name  = "/dev/sda1"
    no_device    = "false"
    virtual_name = "root"
    ebs {
      kms_key_id            = var.kms_key_id
      delete_on_termination = "true"
      encrypted             = "true"
      volume_size           = var.root_vol_size
      volume_type           = var.vol_type
      iops                  = var.iops
      throughput            = var.throughput
    }
  }
  block_device_mappings {
    # Data volume
    device_name  = "/dev/xvdh"
    no_device    = "false"
    virtual_name = "Data Volume 1"
    ebs {
      kms_key_id            = var.kms_key_id
      encrypted             = "true"
      delete_on_termination = "true"
      volume_size           = var.data_vol_size
      volume_type           = var.vol_type
      iops                  = var.iops
      throughput            = var.throughput
    }
  }
  block_device_mappings {
    # Data volume
    device_name  = "/dev/xvdj"
    no_device    = "false"
    virtual_name = "Data Volume 2"
    ebs {
      kms_key_id            = var.kms_key_id
      encrypted             = "true"
      delete_on_termination = "true"
      volume_size           = var.data_vol_size
      volume_type           = var.vol_type
      iops                  = var.iops
      throughput            = var.throughput
    }
  }
  monitoring {
    enabled = "true"
  }
  lifecycle {
    create_before_destroy = "true"
  }
}

# Create AWS Auto Scaling Group
resource "aws_autoscaling_group" "aws-cia-lab-ASG" {
  depends_on                = [aws_launch_template.ec2_launch_templ]
  name                      = "${aws_launch_template.ec2_launch_templ.name}-ASG"
  min_size                  = var.min_size
  desired_capacity          = var.desired_size
  max_size                  = var.max_size
  vpc_zone_identifier       = var.ec2_subnet_ids
  force_delete              = "true"
  health_check_type         = var.asg_health_check_type
  health_check_grace_period = 300
  target_group_arns         = var.alb_target_group_arns
  launch_template {
    id      = aws_launch_template.ec2_launch_templ.id
    version = aws_launch_template.ec2_launch_templ.latest_version #"$Latest"
  }
  # Instance Refresh
  instance_refresh {
    strategy = "Rolling"
    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 50
    }
    triggers = [/*"launch_template",*/ "desired_capacity"] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = "true"
  }
  tag {
    key                 = "Name"
    value               = "aws_cia_lab"
    propagate_at_launch = "true"
  }
  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = "true"
  }
}
# Create AWS Auto Scaling Policy
resource "aws_autoscaling_policy" "aws-cia-lab-scaleup" {
  name                   = "aws-cia-lab-scaleup-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.aws-cia-lab-ASG.name
  policy_type            = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "aws-cia-lab-alarm-up" {
  alarm_name          = "aws-cia-lab-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.aws-cia-lab-ASG.name
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.aws-cia-lab-scaleup.arn]
}
resource "aws_autoscaling_policy" "aws-cia-lab-scaledown" {
  name                   = "aws-cia-lab-scaledown-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.aws-cia-lab-ASG.name
  policy_type            = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "aws-cia-lab-alarm-down" {
  alarm_name          = "aws-cia-lab-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.aws-cia-lab-ASG.name
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.aws-cia-lab-scaledown.arn]
}
