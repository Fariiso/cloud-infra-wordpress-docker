terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

# 1. This registers your computer's public key with DigitalOcean dynamically
resource "digitalocean_ssh_key" "default" {
  name       = "portfolio-key"
  public_key = var.ssh_public_key
}

# 2. This hands the configuration off to your module folder to do the heavy lifting
module "compute_server" {
  source                 = "./modules/compute_server"

  # Hardware Configuration passed into the module
  droplet_image          = "ubuntu-24-04-x64"
  droplet_name           = "wp-portfolio-droplet"
  droplet_region         = "nyc3"
  droplet_size           = "s-1vcpu-1gb"
  ssh_key_ids            = [digitalocean_ssh_key.default.id]
  private_key_path       = var.local_private_key_path

  # Database Secrets passed into the module
  db_user                = var.db_user
  db_password            = var.db_password
  db_name                = var.db_name
  db_root_password       = var.db_root_password
}

# 3. This hands the security/firewall configuration off to your security module folder
module "security" {
  source           = "./modules/security"
  droplet_id       = module.compute_server.droplet_id
  admin_ingress_ip = var.my_admin_ip
}

module "kubernetes_cluster" {
  source       = "./modules/kubernetes_cluster"
  cluster_name = "wp-k8s-cluster"
  region       = "nyc3" # or your preferred region
  node_count   = 2
}


