resource "google_compute_security_policy" "this" {
	name        = var.policy_name
	project     = var.project_id
	description = var.policy_description

	dynamic "rule" {
		for_each = {
			for index, cidr in var.cloudflare_ip_ranges :
			cidr => 1000 + index
		}

		content {
			action   = "allow"
			priority = rule.value

			match {
				versioned_expr = "SRC_IPS_V1"

				config {
					src_ip_ranges = [rule.key]
				}
			}

			description = "Allow Cloudflare ${rule.key}"
			preview     = false
		}
	}

	rule {
		action   = "deny(403)"
		priority = 2147483647

		match {
			versioned_expr = "SRC_IPS_V1"

			config {
				src_ip_ranges = ["*"]
			}
		}

		description = "Default deny all non-Cloudflare traffic"
		preview     = false
	}
}
