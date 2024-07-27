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
      shared-vpc-public  = "10.40.1.0/24"
      shared-vpc-private = "10.40.101.0/24"
      shared-vpc-az      = "us-east-1a"
    }
    b = {
      shared-vpc-public  = "10.40.2.0/24"
      shared-vpc-private = "10.40.102.0/24"
      shared-vpc-az      = "us-east-1b"
    }
    # c = {
    #   shared-vpc-public  = "10.40.3.0/24"
    #   shared-vpc-private = "10.40.103.0/24"
    #   shared-vpc-az      = "us-east-2c"
    # }
  }
}
variable "lamp-app-subnets" {
  type = map(any)
  default = {
    a = {
      lamp-app-public  = "10.20.1.0/24"
      lamp-app-private = "10.20.101.0/24"
      lamp-app-az      = "us-east-1a"
    }
    b = {
      lamp-app-public  = "10.20.2.0/24"
      lamp-app-private = "10.20.102.0/24"
      lamp-app-az      = "us-east-1b"
    }
    # c = {
    #   lamp-app-public  = "10.20.3.0/24"
    #   lamp-app-private = "10.20.103.0/24"
    #   lamp-app-az      = "us-east-2c"
    # }
  }
}
variable "vpc-map" {
  type = map(string)
  default = {
    lamp-app-vpc = "10.20.0.0/16"
    shared-vpc   = "10.40.0.0/16"
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
  default = ["/prod/aws_cia_lab/domain_secret", "/prod/aws_cia_lab/fsxn_secret", "/prod/aws_cia_lab/svm_secret"]
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
  default = "www.devops-terraform.click"
}

variable "domain_name" {
  type    = string
  default = "devops-terraform.click"
}

variable "alt_domain_name" {
  type    = string
  default = "www.devops-terraform.click"
}
