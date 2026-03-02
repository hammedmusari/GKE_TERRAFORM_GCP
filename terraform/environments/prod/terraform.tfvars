project_id = "your-gcp-project-id"
region     = "us-central1"

vpc_name = "prod-vpc"

public_subnets = [
  {
    name          = "prod-public-us-central1"
    region        = "us-central1"
    ip_cidr_range = "10.10.0.0/24"
  }
]

private_subnets = [
  {
    name                          = "prod-private-us-central1"
    region                        = "us-central1"
    ip_cidr_range                 = "10.20.0.0/20"
    pods_secondary_range_name     = "prod-gke-pods"
    pods_secondary_cidr           = "10.30.0.0/16"
    services_secondary_range_name = "prod-gke-services"
    services_secondary_cidr       = "10.40.0.0/20"
  }
]

router_name = "prod-cr-us-central1"
nat_name    = "prod-nat-us-central1"

# IAM
terraform_sa_account_id      = "terraform-deployer-sa"
terraform_sa_display_name    = "Terraform Deployment Service Account"
gke_workload_sa_account_id   = "gke-workload-sa"
gke_workload_sa_display_name = "GKE Workload Service Account"

# Add KSAs that should impersonate the GKE workload GSA via Workload Identity.
workload_identity_ksa = [
  {
    namespace = "default"
    name      = "app-sa"
  }
]

# Optional additional project roles for workload GSA.
gke_workload_project_roles = []

# GKE
cluster_name             = "prod-gke-cluster"
gke_private_subnet_name  = "prod-private-us-central1"
master_ipv4_cidr_block   = "172.16.0.0/28"
enable_private_endpoint  = false
workload_pool            = null
release_channel          = "REGULAR"

master_authorized_networks = [
  {
    cidr_block   = "203.0.113.0/24"
    display_name = "corp-admin-network"
  }
]

node_pool_name    = "primary-pool"
node_machine_type = "e2-standard-4"
node_count        = 1
min_node_count    = 1
max_node_count    = 3

# Cloud Armor / LB
cloud_armor_policy_name        = "allow-cloudflare-only"
cloud_armor_policy_description = "Allows Cloudflare edge IP ranges and denies all other traffic"

global_ip_name       = "prod-gke-ingress-ip"
backend_service_name = "prod-gke-ingress-backend"
health_check_name    = "prod-gke-ingress-hc"
health_check_path    = "/healthz"
health_check_port    = 80
backend_protocol     = "HTTP"
backend_timeout_sec  = 30
