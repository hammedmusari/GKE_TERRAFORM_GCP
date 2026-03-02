resource "google_compute_router" "this" {
	name    = var.router_name
	project = var.project_id
	region  = var.region
	network = var.network_self_link
}

resource "google_compute_router_nat" "this" {
	name                               = var.nat_name
	project                            = var.project_id
	region                             = var.region
	router                             = google_compute_router.this.name
	nat_ip_allocate_option             = "AUTO_ONLY"
	source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

	dynamic "subnetwork" {
		for_each = toset(var.private_subnet_self_links)

		content {
			name                    = subnetwork.value
			source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
		}
	}

	log_config {
		enable = true
		filter = "ALL"
	}
}
