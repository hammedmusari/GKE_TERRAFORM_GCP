variable "project_id" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    name          = string
    region        = string
    ip_cidr_range = string
  }))
  default = []
}

variable "private_subnets" {
  type = list(object({
    name                          = string
    region                        = string
    ip_cidr_range                 = string
    pods_secondary_range_name     = string
    pods_secondary_cidr           = string
    services_secondary_range_name = string
    services_secondary_cidr       = string
  }))
  default = []
}