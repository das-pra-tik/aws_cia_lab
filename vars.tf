variable "aws_profile" {
  type    = string
  default = "tf-admin"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "aws_account_id" {
  type    = string
  default = "502433561161"
}
#----------------------------------------------------------------------
variable "shared-vpc-subnets" {
  type = map(any)
  default = {
    a = {
      shared-vpc-public  = "10.0.1.0/24"
      shared-vpc-private = "10.0.101.0/24"
      shared-vpc-az      = "us-east-1a"
    }
    b = {
      shared-vpc-public  = "10.0.2.0/24"
      shared-vpc-private = "10.0.102.0/24"
      shared-vpc-az      = "us-east-1b"
    }
  }
}
variable "lamp-app-subnets" {
  type = map(any)
  default = {
    a = {
      lamp-app-public   = "10.1.1.0/24"
      lamp-app-private  = "10.1.101.0/24"
      lamp-app-database = "10.1.201.0/24"
      lamp-app-az       = "us-east-1a"
    }
    b = {
      lamp-app-public   = "10.1.2.0/24"
      lamp-app-private  = "10.1.102.0/24"
      lamp-app-database = "10.1.202.0/24"
      lamp-app-az       = "us-east-1b"
    }
  }
}
variable "vpc-map" {
  type = map(string)
  default = {
    lamp-app-vpc = "10.1.0.0/16"
    shared-vpc   = "10.0.0.0/16"
  }
}

variable "amzn_side_asn" {
  type    = string
  default = "64517"
}
#------------------------------------------------------------------------
variable "key_spec" {
  type    = string
  default = "SYMMETRIC_DEFAULT"
}
variable "kms_enabled" {
  type    = bool
  default = true
}
variable "kms_rotation" {
  type    = bool
  default = true
}
variable "kms_deletion_window" {
  type    = number
  default = 7
}
variable "kms_alias_name" {
  type    = string
  default = "alias/cia_lab_kms"
}

#-------------------------------------------------------------------------
variable "ssm_prefix" {
  type    = list(string)
  default = ["/prod/aws_cia_lab/domain_secret", "/prod/aws_cia_lab/fsxn_secret", "/prod/aws_cia_lab/svm_secret", "/prod/aws_cia_lab/rds_secret"]
}

variable "ssm_type" {
  type    = string
  default = "SecureString"
}

variable "ssm_tier" {
  type    = string
  default = "Standard"
}
#-------------------------------------------------------------------------
variable "deployment_type" {
  type    = string
  default = "MULTI_AZ_1"
}

variable "storage_type" {
  type    = string
  default = "SSD"
}

variable "storage_capacity" {
  type    = number
  default = 1024
}

variable "throughput_capacity" {
  type    = number
  default = 512
}

variable "svm_names" {
  type    = list(string)
  default = ["shared-vpc-svm1", "shared-vpc-svm2"]
}
variable "fsxn_ingress_rules" {
  type = map(any)
  default = {
    "-1" = {
      description = "All ICMP"
      from_port   = "-1"
      to_port     = "-1"
      protocol    = "icmp"
      cidrs       = ["10.0.0.0/8"]
    }
    "443" = {
      description = "HTTPS - Access from the Connector to fsxadmin management LIF to send API calls to FSx"
      from_port   = "443"
      to_port     = "443"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "22" = {
      description = "SSH access to the IP address of the cluster management LIF or a node management LIF"
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "111" = {
      description = "Remote procedure call for NFS"
      from_port   = "111"
      to_port     = "111"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "139" = {
      description = "NetBIOS service session for CIFS"
      from_port   = "139"
      to_port     = "139"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "161" = {
      description = "Simple network management protocol"
      from_port   = "161"
      to_port     = "162"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "445" = {
      description = "Microsoft SMB/CIFS over TCP with NetBIOS framing"
      from_port   = "445"
      to_port     = "445"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "635" = {
      description = "NFS mount"
      from_port   = "635"
      to_port     = "635"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "749" = {
      description = "Kerberos"
      from_port   = "749"
      to_port     = "749"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "2049" = {
      description = "NFS server daemon"
      from_port   = "2049"
      to_port     = "2049"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "3260" = {
      description = "iSCSI access through the iSCSI data LIF"
      from_port   = "3260"
      to_port     = "3260"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "4045" = {
      description = "NFS lock daemon"
      from_port   = "4045"
      to_port     = "4045"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "4046" = {
      description = "Network status monitor for NFS"
      from_port   = "4046"
      to_port     = "4046"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "10000" = {
      description = "Backup using NDMP"
      from_port   = "10000"
      to_port     = "10000"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "11104" = {
      description = "Management of intercluster communication sessions for SnapMirror"
      from_port   = "11104"
      to_port     = "11104"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "11105" = {
      description = "SnapMirror data transfer using intercluster LIFs"
      from_port   = "11105"
      to_port     = "11105"
      protocol    = "tcp"
      cidrs       = ["10.0.0.0/8"]
    }
    "111" = {
      description = "Remote procedure call for NFS"
      from_port   = "111"
      to_port     = "111"
      protocol    = "udp"
      cidrs       = ["10.0.0.0/8"]
    }
    "161" = {
      description = "Simple network management protocol"
      from_port   = "161"
      to_port     = "162"
      protocol    = "udp"
      cidrs       = ["10.0.0.0/8"]
    }
    "635" = {
      description = "NFS mount"
      from_port   = "635"
      to_port     = "635"
      protocol    = "udp"
      cidrs       = ["10.0.0.0/8"]
    }
    "2049" = {
      description = "NFS server daemon"
      from_port   = "2049"
      to_port     = "2049"
      protocol    = "udp"
      cidrs       = ["10.0.0.0/8"]
    }
    "4045" = {
      description = "NFS lock daemon"
      from_port   = "4045"
      to_port     = "4045"
      protocol    = "udp"
      cidrs       = ["10.0.0.0/8"]
    }
    "4046" = {
      description = "Network status monitor for NFS"
      from_port   = "4046"
      to_port     = "4046"
      protocol    = "udp"
      cidrs       = ["10.0.0.0/8"]
    }
    "4049" = {
      description = "NFS rquotad protocol"
      from_port   = "4049"
      to_port     = "4049"
      protocol    = "udp"
      cidrs       = ["10.0.0.0/8"]
    }
  }
}
variable "fsxn_egress_rules" {
  type = map(any)
  default = {
    "-1" = {
      description = "All Outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidrs       = ["0.0.0.0/0"]
    }
  }
}
#----------------------------------------------------------------------------------
variable "s3_bucket_name" {
  type    = string
  default = "cdn.devops-terraform.click"
}
variable "domain_name" {
  type    = string
  default = "devops-terraform.click"
}
variable "alt_domain_name_1" {
  type    = string
  default = "cdn.devops-terraform.click"
}
variable "alt_domain_name_2" {
  type    = string
  default = "alb.devops-terraform.click"
}
variable "alb_name" {
  type    = string
  default = "aws-cia-lab-lb"
}
variable "alb_tg_name" {
  type    = string
  default = "aws-cia-lab-tg"
}

variable "algorithm" {
  type    = string
  default = "RSA"
}
variable "rsa_bits" {
  type    = number
  default = 4096
}
variable "key_pair_name" {
  type    = string
  default = "aws_cia_lab"
}
variable "instance_type" {
  type    = string
  default = "t3.medium"
}
variable "root_vol_type" {
  type    = string
  default = "gp3"
}
variable "root_vol_size" {
  type    = number
  default = 20
}
variable "USER_DATA" {
  type    = string
  default = "USER_DATA.sh"
}
variable "lt_name" {
  type    = string
  default = "aws_cia_lab_lt"
}
variable "iops" {
  type    = number
  default = 3000
}
variable "throughput" {
  type    = number
  default = 125
}
variable "data_vol_size" {
  type    = number
  default = 15
}
variable "min_size" {
  type    = number
  default = 2
}
variable "max_size" {
  type    = number
  default = 4
}
variable "desired_size" {
  type    = number
  default = 2
}
variable "asg_health_check_type" {
  type    = string
  default = "ELB"
}
variable "alb_ports" {
  type = map(any)
  default = {
    "80" = {
      description = "HTTP"
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "443" = {
      description = "HTTPS"
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "ec2_ports" {
  type = map(any)
  default = {
    "80" = {
      description = "HTTP"
      port        = 80
      protocol    = "tcp"
      //cidr_blocks = ["0.0.0.0/0"]
      //security_groups = []
    }
    "443" = {
      description = "HTTPS"
      port        = 443
      protocol    = "tcp"
      //cidr_blocks = ["0.0.0.0/0"]
      //security_groups = []
    }
  }
}

variable "rds_ports" {
  type = map(any)
  default = {
    "5432" = {
      description = "port for PostgreSQL"
      port        = 5432
      protocol    = "tcp"
      //cidr_blocks = ["0.0.0.0/0"]
      //security_groups = []
    }
  }
}

#------------------------------------------------------------------------
variable "db_subnet_group_name" {
  type    = string
  default = "aws-cia-lab-subnet-grp"
}

variable "db_instance_class" {
  description = "The instance class to use for RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "The name of the database engine to be used for RDS."
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "The database engine version."
  type        = string
  default     = "12"
}

variable "db_name" {
  description = "Name for the created database."
  type        = string
  default     = "awscialabpostgresql5432"
}

variable "db_storage_type" {
  description = "Storage Type for RDS."
  type        = string
  default     = "gp3"
}

variable "db_allocated_storage" {
  description = "Storage size in GB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Max allocate storage"
  type        = number
  default     = 40
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:00:30-sun:01:30"
}

variable "db_backup_window" {
  description = "Preferred backup window."
  type        = string
  default     = "00:00-00:30"
}

variable "db_backup_retention_period" {
  description = "Backup retention period in days."
  type        = number
  default     = 0
}

variable "db_port" {
  description = "The port on which the database accepts connections."
  type        = string
  default     = "5432"
}

variable "enable_skip_final_snapshot" {
  description = "When DB is deleted and if this variable is false, no final snapshot will be made."
  type        = bool
  default     = true
}

variable "is_public_access" {
  description = "Enable public access for RDS"
  type        = bool
  default     = false
}

variable "enable_multi_az" {
  description = "Create RDS instance in multiple availability zones."
  type        = bool
  default     = true
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "db_user"
}

variable "apply_immediately" {
  description = "Apply immediately, do not set this to true for production"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  default     = true
  type        = bool
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
}

variable "performance_insights_enabled" {
  default     = false
  type        = bool
  description = "Specifies whether Performance Insights are enabled."
}

variable "performance_insights_retention_period" {
  default     = 7
  type        = number
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
}

variable "enabled_cloudwatch_logs_exports" {
  default     = true
  type        = bool
  description = "Indicates that postgresql logs will be configured to be sent automatically to Cloudwatch"
}

variable "s3_access_logs_bucket" {
  type    = string
  default = "aws-cia-lab-s3-access-logs-bucket"
}

variable "default_retention_noncurrent_days" {
  type    = number
  default = 180
}

variable "archive_retention_noncurrent_days" {
  type    = number
  default = 90
}
