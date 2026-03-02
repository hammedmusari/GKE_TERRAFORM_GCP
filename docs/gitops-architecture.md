```text
gitops-repo/
├── bootstrap/
│   ├── argocd-install.yaml
│   └── root-app.yaml                   # App of Apps pattern
├── infrastructure/
│   ├── ingress-controller/             # NGINX/Gateway API manifests
│   ├── cert-manager/                   # Certificate management
│   └── mongodb-operator/               # Operator and CRDs
├── applications/
│   └── microservice-app/
│       ├── kustomization.yaml
│       ├── rollout.yaml                # Argo Rollouts CRD (replaces Deployment)
│       ├── service-active.yaml         # Points to the active environment (Blue)
│       ├── service-preview.yaml        # Points to the staging environment (Green)
│       ├── ingress.yaml                # Routes external traffic to Active Service
│       ├── hpa.yaml                    # Horizontal Pod Autoscaler
│       └── pdb.yaml                    # Pod Disruption Budget
└── datastores/
    └── mongodb/
        ├── mongodb-replicaset.yaml     # Custom Resource for the Operator
        └── secrets-eso.yaml            # External Secrets Operator configuration
```

## MongoDB External Secret Contract

- ExternalSecret manifest: datastores/mongodb/secrets-eso.yaml
- Secret store reference: ClusterSecretStore/external-secrets-store
- Remote secret key: mongodb/credentials
- Created Kubernetes secret: mongodb-credentials (namespace: mongodb)
- Expected keys in generated secret:
  - username
  - password

The MongoDB custom resource (datastores/mongodb/mongodb-replicaset.yaml) consumes mongodb-credentials via spec.users[].passwordSecretRef.name.

## Prerequisites

- External Secrets Operator must be installed in the cluster.
- A ClusterSecretStore named external-secrets-store must exist.
- The store backend must have working authentication (for example: GCP Secret Manager, AWS Secrets Manager, or HashiCorp Vault).
- The remote secret mongodb/credentials must contain username and password properties.
- Namespace mongodb must exist or be created before syncing datastore manifests.

## Argo CD Applications

| Application | Source | Destination Namespace | Sync Wave |
| --- | --- | --- | --- |
| root-app | path: `k8s-gitops/bootstrap/apps` | `argocd` | `0` |
| infrastructure-app | path: `k8s-gitops/infrastructure` | cluster-scoped/in-manifest | `0` |
| applications-app | path: `k8s-gitops/applications` | cluster-scoped/in-manifest | `10` |
| datastores-app | path: `datastores` | cluster-scoped/in-manifest | `20` |
| ingress-nginx | repo/path: `kubernetes/ingress-nginx` / `deploy/static/provider/cloud` | `ingress-nginx` | `10` |
| cert-manager | chart: `cert-manager` (`https://charts.jetstack.io`) | `cert-manager` | `0` |
| mongodb-community-operator | chart: `community-operator` (`https://mongodb.github.io/helm-charts`) | `mongodb-operator` | `20` |

Sync order: `root-app` syncs child apps first, then child apps reconcile infrastructure, applications, and datastores resources.

Datastore sync waves: `datastores/mongodb/secrets-eso.yaml` uses wave `0`, and `datastores/mongodb/mongodb-replicaset.yaml` uses wave `10`.
