# Cloud Infrastructure & Platform Evolution: From Single-Node Containerization to Managed Kubernetes

This repository contains the Infrastructure as Code (IaC) used to automatically provision, configure, and secure a containerized application environment on DigitalOcean using Terraform, scaling from baseline Docker Compose setups up to a production-ready Kubernetes cluster.

As a network engineering professional transitioning to DevOps, this project serves as a practical implementation of secure infrastructure topology, modular configuration design, containerized application lifecycles, and cloud-native orchestration.

---

## ️ Architecture & Modular Topology
The infrastructure has been evolved from a monolithic single-node instance into a highly resilient, **Cloud-Native Cluster Architecture** separating global edge state from container runtime environments:

* **Infrastructure Provider:** DigitalOcean (Provisioned via Terraform)
* **Orchestration Engine:** DigitalOcean Kubernetes Service (DOKS) managing automated application pod lifecycles, self-healing container deployments, and internal cluster networking.
* **Traffic Routing & Load Balancing:** A managed DigitalOcean Load Balancer handles public edge interfaces, terminating outside requests and routing incoming HTTP traffic straight into the Kubernetes cluster.
* **Security & Network Hardening:** Cloud Firewalls strictly isolate backend node pools, ensuring public ingress points are restricted solely to expected web ports, while administrative access is tightly bound to zero-trust parameters.
* **Application Stability & Proxy Fixes:** Hardened WordPress environment definitions inside `wp-config.php` inject deterministic canonical domains (`http://eredawen.me`), bypassing routing loops and timeout issues commonly caused by upstream TLS/HTTP load-balancer offloading.

---

## Project Directory Structure
The codebase is organized into reusable components separating compute provisioning, network edge security, and declarative container state definitions:

```text
.
├── main.tf                     # Root blueprint calling the custom infrastructure modules
├── variables.tf                # Global infrastructure input variables
├── README.md                   # System and architecture documentation
│
├── k8s/                        # Kubernetes Orchestration Manifests
│   ├── wordpress-deployment.yaml  # WordPress application deployment, specs, & env configurations
│   ├── mysql-deployment.yaml      # Stateful MySQL database deployment configurations
│   └── services.yaml              # ClusterIP and LoadBalancer edge routing definitions
│
├── modules/                    # Custom Reusable Infrastructure Modules (Legacy/Foundation)
│   ├── compute_server/         # Handles baseline Droplet engine provisioning
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   │
│   ├── security/               # Enforces the cloud perimeter firewall matrix
│   │   └── main.tf
│   │
│   └── config/                 # Coordinates environment and server setups
│       ├── .env                # Runtime environment parameters
│       ├── docker-compose.yml  # Legacy single-node application architecture mapping
│       ├── env.tpl             # Dynamic configuration variables template
│       └── nginx/
│           └── default.conf    # Custom reverse proxy configuration block
│
└── images/                     # Secure Operational Verification Visuals
    ├── digitalocean-firewall-matrix.jpg
    ├── docker-compose-ps-status.jpg
    └── k8s-cluster-pod-status.jpg  # Live Kubernetes pod verification capture
```
---
##   ️ 90‑Day DevOps Evolution Roadmap
* [x] **Phase 1: Foundations** – Automate foundational cloud infrastructure using baseline monolithic Terraform.
* [x] **Phase 2: Modular Refactoring** – Deconstruct monolithic codebase into reusable, decoupled Terraform modules.
* [x] **Phase 3: Containerization & Hardening** – Containerize application runtime with Docker Compose and harden perimeter topologies.
* [x] **Phase 4: Cloud-Native Scale [COMPLETED]** – Migrate, scale, and orchestrate the entire architecture onto an enterprise-grade Kubernetes platform (DOKS) behind a managed cloud load balancer.

---

### Phase 3 Milestone Summary
* **Decoupled Footprint:** Separated the compute instance layer dynamically from global infrastructure variables using modular inputs/outputs.
* **Zero-Trust Network Perimeter:** Restricted administrative port `22` (SSH) access exclusively to a verified variable management IP block.
* **Unified Manifest Lifecycle:** Refactored and validated the multi-container Docker Compose application stack inside modular Terraform tracking pathways.

### Phase 4 Milestone Summary (Kubernetes Migration)
* **Cloud-Native Infrastructure:** Migrated the runtime environment out of legacy single-node Docker Compose into a managed DigitalOcean Kubernetes (DOKS) cluster layout.
* **Edge Traffic Management:** Provisioned a cloud-managed Load Balancer mapping incoming public traffic for `eredawen.me` directly to active cluster target nodes.
* **Network Loop Mitigation:** Fixed common multi-tier proxy loopbacks by overriding internal application configuration blocks (`WP_HOME` / `WP_SITEURL`) dynamically inside active container volumes.
* **Container Introspection & Auditing:** Utilized remote container runtime execution (`kubectl exec`) to securely authenticate, drop into MySQL shells, and programmatically query production backend database schemas (`wordpress_db`).

---

## Phase 3 & 4 Operational Verification
To confirm the baseline perimeter isolation, container runtime environments, and successful cloud-native migration, the following operational state captures were gathered post-deployment:

### 1. Cloud Perimeter Firewall Matrix
![DigitalOcean Cloud Perimeter Firewall Matrix](images/digitalocean-firewall-matrix.jpg)

### 2. Isolated Container Cluster Status (Phase 3 Legacy)
![Docker Compose Isolated Container Cluster Status](images/docker-compose-ps-status.jpg)

### 3. Kubernetes Live Pod Status (Phase 4 Ingress)
![Kubernetes Live Pod Status](images/k8s-cluster-pod-status.jpg)

### 4. Edge Ingress DNS Propagation
To verify that public traffic safely bypasses the legacy Droplet engine and targets the managed cloud load balancer directly, an active network resolution trace was executed:
```powershell
> nslookup eredawen.me
Non-authoritative answer:
Name:    eredawen.me
Address:  129.212.135.99