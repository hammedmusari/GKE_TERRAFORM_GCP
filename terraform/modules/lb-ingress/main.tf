resource "google_compute_global_address" "ingress_ip" {
	project      = var.project_id
	name         = var.global_ip_name
	address_type = "EXTERNAL"
	ip_version   = "IPV4"
}

resource "google_compute_health_check" "ingress" {
	project = var.project_id
	name    = var.health_check_name

	check_interval_sec  = 10
	timeout_sec         = 5
	healthy_threshold   = 2
	unhealthy_threshold = 3

	http_health_check {
		port         = var.health_check_port
		request_path = var.health_check_path
	}
}

resource "google_compute_backend_service" "gke_ingress" {
	project               = var.project_id
	name                  = var.backend_service_name
	protocol              = var.backend_protocol
	load_balancing_scheme = "EXTERNAL_MANAGED"
	timeout_sec           = var.backend_timeout_sec
	health_checks         = [google_compute_health_check.ingress.id]
	security_policy       = var.cloud_armor_policy_self_link

	log_config {
		enable      = true
		sample_rate = 1.0
	}
}
