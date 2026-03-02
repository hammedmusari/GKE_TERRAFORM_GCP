locals {
	workload_identity_members = {
		for ksa in var.workload_identity_ksa :
		"${ksa.namespace}/${ksa.name}" => "serviceAccount:${var.project_id}.svc.id.goog[${ksa.namespace}/${ksa.name}]"
	}
}

resource "google_service_account" "gke_workload" {
	project      = var.project_id
	account_id   = var.gke_workload_sa_account_id
	display_name = var.gke_workload_sa_display_name
}

resource "google_service_account" "terraform_deployer" {
	project      = var.project_id
	account_id   = var.terraform_sa_account_id
	display_name = var.terraform_sa_display_name
}

resource "google_project_iam_member" "terraform_sa_roles" {
	for_each = toset(var.terraform_project_roles)

	project = var.project_id
	role    = each.value
	member  = "serviceAccount:${google_service_account.terraform_deployer.email}"
}

resource "google_project_iam_member" "gke_workload_sa_roles" {
	for_each = toset(var.gke_workload_project_roles)

	project = var.project_id
	role    = each.value
	member  = "serviceAccount:${google_service_account.gke_workload.email}"
}

resource "google_service_account_iam_member" "workload_identity_user" {
	for_each = local.workload_identity_members

	service_account_id = google_service_account.gke_workload.name
	role               = "roles/iam.workloadIdentityUser"
	member             = each.value
}
