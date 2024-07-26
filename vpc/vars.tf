variable "vpc-map" {
  type = map(string)
}

variable "lamp-app-subnets" {
  type = map(any)
}

variable "shared-vpc-subnets" {
  type = map(any)
}

variable "tgw-id" {
  type = string
}

variable "lamp-app-vpc-cidr" {
  type = string
}

variable "shared-vpc-cidr" {
  type = string
}
