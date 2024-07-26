variable "aws_profile" {
  type    = string
  default = "tf-admin"
}
variable "aws_region" {
  type    = string
  default = "us-east-2"
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
      shared-vpc-az      = "us-east-2a"
    }
    b = {
      shared-vpc-public  = "10.40.2.0/24"
      shared-vpc-private = "10.40.102.0/24"
      shared-vpc-az      = "us-east-2b"
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
      lamp-app-az      = "us-east-2a"
    }
    b = {
      lamp-app-public  = "10.20.2.0/24"
      lamp-app-private = "10.20.102.0/24"
      lamp-app-az      = "us-east-2b"
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
variable "ssm_name" {
  type    = string
  default = "/production/aws_cia_lab/secret"
}

variable "ssm_type" {
  type    = string
  default = "SecureString"
}

variable "ssm_tier" {
  type    = string
  default = "Standard"
}

variable "data_type" {
  type    = string
  default = "text"
}

#-------------------------------------------------------------------------
