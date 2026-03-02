locals {
	public_subnets_by_name  = { for subnet in var.public_subnets : subnet.name => subnet }
	private_subnets_by_name = { for subnet in var.private_subnets : subnet.name => subnet }
}

resource "google_compute_network" "this" {
	name                    = var.vpc_name
	project                 = var.project_id
	auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
	for_each = local.public_subnets_by_name

	name                     = each.value.name
	ip_cidr_range            = each.value.ip_cidr_range
	region                   = each.value.region
	network                  = google_compute_network.this.id
	project                  = var.project_id
	private_ip_google_access = false
}

resource "google_compute_subnetwork" "private" {
	for_each = local.private_subnets_by_name

	name                     = each.value.name
	ip_cidr_range            = each.value.ip_cidr_range
	region                   = each.value.region
	network                  = google_compute_network.this.id
	project                  = var.project_id
	private_ip_google_access = true

	secondary_ip_range {
		range_name    = each.value.pods_secondary_range_name
		ip_cidr_range = each.value.pods_secondary_cidr
	}

	secondary_ip_range {
		range_name    = each.value.services_secondary_range_name
		ip_cidr_range = each.value.services_secondary_cidr
	}
}
