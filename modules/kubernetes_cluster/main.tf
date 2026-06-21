# modules/kubernetes_cluster/main.tf

# Fetch the latest stable Kubernetes version available on DigitalOcean
data "digitalocean_kubernetes_versions" "current" {
  version_prefix = "1.35." # Bumping to a current supported version line
}

resource "digitalocean_kubernetes_cluster" "doks" {
  name    = var.cluster_name
  region  = var.region
  version = data.digitalocean_kubernetes_versions.current.latest_version

  # The Worker Node Pool (The virtual servers running your application pods)
  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb" # Smoothly runs both WordPress and MariaDB
    node_count = var.node_count
    auto_scale = false
  }
}


resource "local_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.doks.kube_config[0].raw_config
  filename = "${path.module}/kubeconfig"
}


terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

