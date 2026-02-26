# AWS Infrastructure Automation & Progressive Delivery (Canary)

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-web-services&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=flat&logo=kubernetes&logoColor=white)
![NGINX](https://img.shields.io/badge/nginx-%23009639.svg?style=flat&logo=nginx&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=flat&logo=Prometheus&logoColor=white)

A production-grade **Site Reliability Engineering (SRE)** laboratory that orchestrates a highly available cloud infrastructure and executes a **Zero-Downtime Canary Deployment** driven by metrics.

## 🚀 Engineering Scope

This project implements a **Platform Engineering** workflow separating Infrastructure as Code (Terraform) from Application Workloads (Kubernetes Manifests).

* **Immutable Cloud Infrastructure:** Full lifecycle management of a secure AWS network topology (VPC, Private/Public Subnets, NAT Gateway) and Compute (EKS Cluster).
* **Progressive Delivery (Canary):** Implementation of an 80/20 traffic split strategy using NGINX Ingress annotations to mitigate the risks of releasing new features.
* **Zero-Downtime Rollback:** Instant traffic routing manipulation to revert 100% of users to a stable version seamlessly without dropping active connections.
* **Observability by Design:** Automated deployment of the `kube-prometheus-stack` via Helm directly within Terraform for real-time traffic and application monitoring.

## 📐 Architecture

```mermaid
graph TD;
    Terraform[Terraform IaC] -->|Provisions Network & Compute| AWS[AWS VPC & EKS Cluster];
    Terraform -->|Helm Provider| Monitoring[Prometheus & Grafana];
    User[End User] -->|HTTP Request| Ingress[NGINX Ingress Controller];
    Ingress -->|80% Traffic| SVC1[Service V1 - Stable];
    Ingress -->|20% Traffic| SVC2[Service V2 - Canary];
    SVC1 --> Pods1[V1 Pods 🟢];
    SVC2 --> Pods2[V2 Pods 🔵];
    Monitoring -.->|Scrape Traffic Metrics| Ingress;
```

## 🛠 Tech Stack

| Component | Technology | Role |
| :--- | :--- | :--- |
| **Provisioning** | **Terraform** | State-managed infrastructure creation (HCL). |
| **Cloud** | **Amazon Web Services** | VPC, NAT Gateway, EKS (Elastic Kubernetes Service). |
| **Orchestration** | **Kubernetes** | Container lifecycle management (Deployments, Services). |
| **Traffic Mgmt** | **NGINX Ingress** | Traffic shaping, weighted routing, and entry point. |
| **Observability** | **Helm & Prometheus** | Package management and real-time metric scraping. |

## ⚙️ Repository Structure & Execution

The project enforces a strict separation of concerns:

### 1. Infrastructure Foundation (`/terraform`)
Contains the HCL manifests required to build the underlying AWS architecture.
* Execution involves standard IaC workflow: `terraform init`, `terraform fmt`, and `terraform plan` / `terraform apply`.
* *Security Note:* State files and `.terraform` directories are strictly ignored via `.gitignore` to prevent secret leakage.

### 2. Application Workload (`/k8s`)
Contains the Kubernetes manifests representing the application lifecycle.
* **`app-v1.yaml`**: Deploys the stable green release.
* **`app-v2.yaml`**: Deploys the new canary blue release.
* **`ingress.yaml`**: Contains the magic `canary-weight: "20"` annotation. By changing this value to `0` and applying (`kubectl apply -f ingress.yaml`), an instant rollback is achieved.

---
*DevOps Engineering Portfolio Project*