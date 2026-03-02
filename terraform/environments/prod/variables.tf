variable "project_id" {
  type = string
}

variable "region" {
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
}

variable "router_name" {
  type = string
}

variable "nat_name" {
  type = string
}

variable "gke_workload_sa_account_id" {
  type    = string
  default = "gke-workload-sa"
}

variable "gke_workload_sa_display_name" {
  type    = string
  default = "GKE Workload Service Account"
}

variable "terraform_sa_account_id" {
  type    = string
  default = "terraform-deployer-sa"
}

variable "terraform_sa_display_name" {
  type    = string
  default = "Terraform Deployment Service Account"
}

variable "terraform_project_roles" {
  type = list(string)
  default = [
    "roles/compute.networkAdmin",
    "roles/container.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/resourcemanager.projectIamAdmin"
  ]
}

variable "gke_workload_project_roles" {
  type    = list(string)
  default = []
}

variable "workload_identity_ksa" {
  type = list(object({
    namespace = string
    name      = string
  }))
}

variable "cluster_name" {
  type = string
}

variable "gke_private_subnet_name" {
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

variable "node_count" {
  type    = number
  default = 1
}

variable "min_node_count" {
  type = number
}

variable "max_node_count" {
  type = number
}

variable "cloud_armor_policy_name" {
  type    = string
  default = "allow-cloudflare-only"
}

variable "cloud_armor_policy_description" {
  type    = string
  default = "Allows Cloudflare edge IP ranges and denies all other traffic"
}

variable "cloudflare_ip_ranges" {
  type = list(string)
  default = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
    "2400:cb00::/32",
    "2606:4700::/32",
    "2803:f800::/32",
    "2405:b500::/32",
    "2405:8100::/32",
    "2a06:98c0::/29",
    "2c0f:f248::/32"
  ]
}

variable "global_ip_name" {
  type    = string
  default = "gke-ingress-global-ip"
}

variable "backend_service_name" {
  type    = string
  default = "gke-ingress-backend-service"
}

variable "health_check_name" {
  type    = string
  default = "gke-ingress-health-check"
}

variable "health_check_path" {
  type    = string
  default = "/healthz"
}

variable "health_check_port" {
  type    = number
  default = 80
}

variable "backend_protocol" {
  type    = string
  default = "HTTP"
}

variable "backend_timeout_sec" {
  type    = number
  default = 30
}