variable "project_id" {
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