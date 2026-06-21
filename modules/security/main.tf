terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Variable to link the firewall to the droplet
variable "droplet_id" {
  type        = string
  description = "The ID of the Droplet we want to protect"
}

# NEW: Variable to pass your secure management network/IP
variable "admin_ingress_ip" {
  type        = string
  description = "The specific public IP or CIDR block allowed to SSH into the host"
}

resource "digitalocean_firewall" "web_firewall" {
  name        = "portfolio-gateway-firewall"
  droplet_ids = [var.droplet_id]

  # --- INBOUND RULES ---

  # 1. Allow standard web traffic (HTTP)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # 2. Allow secure web traffic (HTTPS)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # 3. HARDENED: Administrative access restricted to your IP variable only
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.admin_ingress_ip]
  }

  # --- OUTBOUND RULES ---
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
