variable "amzn_side_asn" {
  type = string
}

variable "lamp-app-vpc-id" {
  type = string
}

variable "shared-vpc-id" {
  type = string
}
/*
variable "lamp-app-vpc-public-subnet-ids" {
  type = list(string)
}

variable "shared-vpc-public-subnet-ids" {
  type = list(string)
}
*/
variable "lamp-app-vpc-private-subnet-ids" {
  type = list(string)
}

variable "shared-vpc-private-subnet-ids" {
  type = list(string)
}

variable "lamp-app-vpc-cidr" {
  type = string
}

variable "shared-vpc-cidr" {
  type = string
}
