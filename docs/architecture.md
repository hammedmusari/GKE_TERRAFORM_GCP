terraform/
├── environments/
│   └── prod/
│       ├── main.tf             # Calls modules
│       ├── variables.tf
│       ├── terraform.tfvars    # Environment-specific values
│       ├── outputs.tf
│       └── backend.tf          # GCS bucket for remote state
└── modules/
    ├── vpc/                    # VPC, Subnets, Secondary Ranges
    ├── nat/                    # Cloud Router, Cloud NAT
    ├── gke/                    # Private Cluster, Node Pools, Auth Networks
    ├── iam/                    # Workload Identity, Service Accounts
    ├── cloud-armor/            # Rules to whitelist Cloudflare IPs
    └── lb-ingress/             # Static IP allocation, Load Balancer prep