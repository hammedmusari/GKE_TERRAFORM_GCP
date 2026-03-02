module "vpc" {
	source = "../../modules/vpc"

	project_id      = var.project_id
	vpc_name        = var.vpc_name
	public_subnets  = var.public_subnets
	private_subnets = var.private_subnets
}

module "nat" {
	source = "../../modules/nat"

	project_id                 = var.project_id
	region                     = var.region
	network_self_link          = module.vpc.network_self_link
	router_name                = var.router_name
	nat_name                   = var.nat_name
	private_subnet_self_links  = module.vpc.private_subnet_self_links
}

module "iam" {
	source = "../../modules/iam"

	project_id                    = var.project_id
	gke_workload_sa_account_id    = var.gke_workload_sa_account_id
	gke_workload_sa_display_name  = var.gke_workload_sa_display_name
	terraform_sa_account_id       = var.terraform_sa_account_id
	terraform_sa_display_name     = var.terraform_sa_display_name
	terraform_project_roles       = var.terraform_project_roles
	gke_workload_project_roles    = var.gke_workload_project_roles
	workload_identity_ksa         = var.workload_identity_ksa
}

module "gke" {
	source = "../../modules/gke"

	project_id                    = var.project_id
	region                        = var.region
	cluster_name                  = var.cluster_name
	network_self_link             = module.vpc.network_self_link
	private_subnet_self_link      = module.vpc.private_subnet_self_links_by_name[var.gke_private_subnet_name]
	pods_secondary_range_name     = module.vpc.private_subnet_pods_range_names_by_name[var.gke_private_subnet_name]
	services_secondary_range_name = module.vpc.private_subnet_services_range_names_by_name[var.gke_private_subnet_name]
	master_ipv4_cidr_block        = var.master_ipv4_cidr_block
	enable_private_endpoint       = var.enable_private_endpoint
	workload_pool                 = var.workload_pool
	master_authorized_networks    = var.master_authorized_networks
	release_channel               = var.release_channel
	node_pool_name                = var.node_pool_name
	node_machine_type             = var.node_machine_type
	node_service_account          = module.iam.gke_workload_service_account_email
	node_count                    = var.node_count
	min_node_count                = var.min_node_count
	max_node_count                = var.max_node_count

	depends_on = [module.nat]
}

module "cloud_armor" {
	source = "../../modules/cloud-armor"

	project_id          = var.project_id
	policy_name         = var.cloud_armor_policy_name
	policy_description  = var.cloud_armor_policy_description
	cloudflare_ip_ranges = var.cloudflare_ip_ranges
}

module "lb_ingress" {
	source = "../../modules/lb-ingress"

	project_id                     = var.project_id
	global_ip_name                 = var.global_ip_name
	backend_service_name           = var.backend_service_name
	health_check_name              = var.health_check_name
	health_check_path              = var.health_check_path
	health_check_port              = var.health_check_port
	backend_protocol               = var.backend_protocol
	backend_timeout_sec            = var.backend_timeout_sec
	cloud_armor_policy_self_link   = module.cloud_armor.security_policy_self_link

	depends_on = [module.gke]
}
