variable "project_id" {
  type = string
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

variable "cloud_armor_policy_self_link" {
  type = string
}