output "global_ip_address" {
  value = google_compute_global_address.ingress_ip.address
}

output "global_ip_name" {
  value = google_compute_global_address.ingress_ip.name
}

output "backend_service_name" {
  value = google_compute_backend_service.gke_ingress.name
}

output "backend_service_self_link" {
  value = google_compute_backend_service.gke_ingress.self_link
}