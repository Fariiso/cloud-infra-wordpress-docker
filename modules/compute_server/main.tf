terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "web" {
  image     = var.droplet_image
  name      = var.droplet_name
  region    = var.droplet_region
  size      = var.droplet_size
  ssh_keys  = var.ssh_key_ids
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt-get update -y
              apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
              systemctl start docker
              systemctl enable docker
              EOF



# 1. Clean up any old configurations on the server
  provisioner "remote-exec" {
    inline = [
      # This loops until the background Docker installer is 100% finished
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for Docker installation to finish...'; sleep 5; done",

      "mkdir -p /srv/wordpress",
      "cd /srv/wordpress && docker compose down --remove-orphans || true",
      "rm -rf /srv/wordpress/nginx"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_key_path)
      host        = self.ipv4_address
    }
  }

  # 2. Upload the brand new config folder (including Nginx rules!)
  provisioner "file" {
    source      = "${path.module}/config/"
    destination = "/srv/wordpress"

    connection {
      type = "ssh"
      user = "root"
      private_key = file(var.private_key_path)
      host = self.ipv4_address
    }
  }

  # 3. Fire up our brand new Nginx + WordPress stack
  provisioner "remote-exec" {
    inline = [
      "cd /srv/wordpress",
      "docker compose up -d"
    ]

    connection {
      type = "ssh"
      user = "root"
      private_key = file(var.private_key_path)
      host = self.ipv4_address
    }
  }

}
  resource "digitalocean_volume" "wordpress_storage" {
    region = var.droplet_region # Using the variable makes it match automatically!
    name                    = "wordpress-data-volume"
    size                    = 10
    description             = "Persistent block storage for WordPress uploads and database"
    initial_filesystem_type = "ext4"

 }

  resource "digitalocean_volume_attachment" "wordpress_storage_attach" {
    droplet_id = digitalocean_droplet.web.id
    volume_id  = digitalocean_volume.wordpress_storage.id

  }


# 1. This generates the file locally FIRST
resource "local_file" "env_config" {
  content = templatefile("${path.module}/config/env.tpl", {
    db_user          = var.db_user
    db_password      = var.db_password
    db_name          = var.db_name
    db_root_password = var.db_root_password
  })
  filename = "${path.module}/config/.env"
}

# 2. This FORCES the upload to wait until env_config is completely ready
resource "null_resource" "upload_env" {
  depends_on = [local_file.env_config]

  provisioner "file" {
    source      = "${path.module}/config/.env"
    destination = "/srv/wordpress/.env"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_key_path)
      host        = digitalocean_droplet.web.ipv4_address
    }
  }

  # Automatically restarts docker when the .env file changes
  provisioner "remote-exec" {
    inline = [
      "cd /srv/wordpress",
      "docker compose down --volumes --remove-orphans || true",
      "docker compose up -d"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_key_path)
      host        = digitalocean_droplet.web.ipv4_address
    }
  }
}

