GKE_TERRAFORM_GCP Production Platform (Portfolio Project)
Overview

This project demonstrates a production-style DevOps platform built on Google Cloud Platform (GCP) using:

Terraform (Infrastructure as Code)

GKE (Kubernetes)

ArgoCD (GitOps)

Kustomize

Argo Rollouts (Blue/Green deployments)

MongoDB Operator

GitHub Actions CI/CD

Cloud Armor + Ingress

It simulates a real-world cloud-native microservice deployment pipeline.

🏗 Architecture Overview

Infrastructure is provisioned via Terraform.
Application delivery is handled via GitOps (ArgoCD).
Deployments use Blue/Green strategy with Argo Rollouts.

(Insert diagram image from /docs/architecture.png)

📂 Repository Structure
portfolio-devops-gcp/
├── app/              # Sample containerized microservice
├── terraform/        # GCP infrastructure (modular)
├── k8s-gitops/       # Kubernetes GitOps manifests
├── .github/          # CI/CD workflows
├── docs/             # Architecture diagrams
└── README.md
☁️ Infrastructure Layer (Terraform)

Provisioned resources include:

Custom VPC with private subnets

Cloud NAT

Private GKE cluster

Workload Identity

Cloud Armor security policies

GCS remote state backend

Deploy:

cd terraform/environments/prod
terraform init
terraform plan
terraform apply
🔄 GitOps Layer (ArgoCD)

Implements:

App of Apps pattern

Infrastructure layer (Ingress, cert-manager, MongoDB operator)

Datastore layer (MongoDB ReplicaSet)

Application layer (Argo Rollouts Blue/Green)

Bootstrap ArgoCD:

kubectl apply -f k8s-gitops/bootstrap/
🔁 CI/CD Pipelines

GitHub Actions performs:

Terraform validation

Docker image build & push

Kubernetes manifest linting

🎯 Deployment Strategy

Blue/Green rollout using Argo Rollouts

Active and Preview services

Horizontal Pod Autoscaling

Pod Disruption Budget

🔐 Security Considerations

Private GKE cluster

Cloud Armor protection

Workload Identity (no static credentials)

External Secrets Operator

🧠 Skills Demonstrated

Infrastructure as Code

GitOps workflow design

Kubernetes platform engineering

Secure GCP architecture

CI/CD automation

Cloud-native deployment strategies
