locals {
  effective_workload_pool = coalesce(var.workload_pool, "${var.project_id}.svc.id.goog")
}

resource "google_container_cluster" "this" {
	name     = var.cluster_name
	project  = var.project_id
	location = var.region

	network    = var.network_self_link
	subnetwork = var.private_subnet_self_link

	remove_default_node_pool = true
	initial_node_count       = 1

	private_cluster_config {
		enable_private_nodes    = true
		enable_private_endpoint = var.enable_private_endpoint
		master_ipv4_cidr_block  = var.master_ipv4_cidr_block
	}

	ip_allocation_policy {
		cluster_secondary_range_name  = var.pods_secondary_range_name
		services_secondary_range_name = var.services_secondary_range_name
	}

	workload_identity_config {
		workload_pool = local.effective_workload_pool
	}

	master_authorized_networks_config {
		dynamic "cidr_blocks" {
			for_each = var.master_authorized_networks

			content {
				cidr_block   = cidr_blocks.value.cidr_block
				display_name = cidr_blocks.value.display_name
			}
		}
	}

	release_channel {
		channel = var.release_channel
	}
}

resource "google_container_node_pool" "primary" {
	name     = var.node_pool_name
	project  = var.project_id
	location = var.region
	cluster  = google_container_cluster.this.name

	node_count = var.node_count

	autoscaling {
		min_node_count = var.min_node_count
		max_node_count = var.max_node_count
	}

	node_config {
		machine_type    = var.node_machine_type
		service_account = var.node_service_account
		oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

		workload_metadata_config {
			mode = "GKE_METADATA"
		}
	}
}
