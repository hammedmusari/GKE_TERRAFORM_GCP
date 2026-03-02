variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "network_self_link" {
  type = string
}

variable "private_subnet_self_link" {
  type = string
}

variable "pods_secondary_range_name" {
  type = string
}

variable "services_secondary_range_name" {
  type = string
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "enable_private_endpoint" {
  type    = bool
  default = false
}

variable "workload_pool" {
  type    = string
  default = null
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))

  validation {
    condition     = length(var.master_authorized_networks) > 0
    error_message = "master_authorized_networks must contain at least one CIDR block."
  }
}

variable "release_channel" {
  type    = string
  default = "REGULAR"
}

variable "node_pool_name" {
  type = string
}

variable "node_machine_type" {
  type = string
}

variable "node_service_account" {
  type = string
}

variable "node_count" {
  type    = number
  default = 1
}

variable "min_node_count" {
  type = number
}

variable "max_node_count" {
  type = number

  validation {
    condition     = var.max_node_count >= var.min_node_count
    error_message = "max_node_count must be greater than or equal to min_node_count."
  }
}