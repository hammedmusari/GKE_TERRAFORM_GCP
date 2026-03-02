output "network_self_link" {
  value = google_compute_network.this.self_link
}

output "public_subnet_names" {
  value = [for subnet in google_compute_subnetwork.public : subnet.name]
}

output "private_subnet_names" {
  value = [for subnet in google_compute_subnetwork.private : subnet.name]
}

output "private_subnet_self_links" {
  value = [for subnet in google_compute_subnetwork.private : subnet.self_link]
}

output "private_subnet_self_links_by_name" {
  value = {
    for name, subnet in google_compute_subnetwork.private :
    name => subnet.self_link
  }
}

output "private_subnet_pods_range_names_by_name" {
  value = {
    for name, subnet in local.private_subnets_by_name :
    name => subnet.pods_secondary_range_name
  }
}

output "private_subnet_services_range_names_by_name" {
  value = {
    for name, subnet in local.private_subnets_by_name :
    name => subnet.services_secondary_range_name
  }
}

output "subnet_names" {
  value = concat(
    [for subnet in google_compute_subnetwork.public : subnet.name],
    [for subnet in google_compute_subnetwork.private : subnet.name]
  )
}