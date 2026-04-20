# Inception-of-Things

A comprehensive project exploring Infrastructure as Code (IaC), Container Orchestration, and GitOps workflows. This project documents the progression from manual VM configuration to a fully automated CI/CD pipeline using K3s, K3d, ArgoCD, and GitLab.

## 📋 Project Roadmap

### Part 1: K3s Cluster with Vagrant
The foundation of the project involves setting up a lightweight Kubernetes (K3s) cluster using Virtual Machines.
- **Infrastructure:** Two VMs managed via **Vagrant**.
- **Role Distribution:**
    - **Server Node:** Acts as the K3s control plane.
    - **Agent Node:** Joined to the cluster as a worker.
- **Goal:** Establish secure communication between the controller and the agent.

### Part 2: Application Deployment & Ingress
Focuses on managing application workloads and external traffic routing.
- **Services:** Three applications deployed as services (`app1.com`, `app2.com`, `app3.com`).
- **Scaling:**
    - `app1` and `app3`: 1 replica.
    - `app2`: 3 replicas for high availability.
- **Ingress:** Implemented **Nginx Ingress Controller** to manage host-based routing.

### Part 3: GitOps with K3d & ArgoCD
The implementation of a modern GitOps workflow where "Git is the single source of truth."
- **Cluster:** A K3d cluster running inside Docker.
- **Network:** Disabled default Traefik in favor of **Nginx Ingress**.
- **ArgoCD:**
    - Installed in the `argocd` namespace.
    - Linked to a GitHub repository (Source).
    - Targeted the K3d cluster (Destination).
- **Automation:** - Auto-sync enabled for the `main` branch.
    - **Prune** enabled to automatically delete cluster resources if removed from Git.
    - Apps deployed within a dedicated `dev` namespace.

### Bonus: Local GitOps with GitLab & Helm
A deep dive into self-hosted infrastructure and resource optimization.
- **Source of Truth:** A local **GitLab** instance instead of GitHub.
- **Deployment:** Installed via **Helm** (Kubernetes Package Manager).
- **Optimization:** - Custom `values.yaml` to disable unnecessary heavy GitLab services.
    - Resource constraints: Each GitLab pod restricted to **1 replica**.
    - Defined **CPU/Memory limits** and storage quotas to ensure performance on local hardware.

---

## 🛠 Tech Stack
- **Orchestration:** K3s, K3d
- **Infrastructure:** Vagrant, Docker
- **GitOps:** ArgoCD
- **Package Management:** Helm
- **SCM:** GitHub & GitLab
- **Ingress:** Nginx
