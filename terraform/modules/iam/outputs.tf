output "gke_workload_service_account_email" {
  value = google_service_account.gke_workload.email
}

output "terraform_service_account_email" {
  value = google_service_account.terraform_deployer.email
}

output "gke_workload_service_account_name" {
  value = google_service_account.gke_workload.name
}