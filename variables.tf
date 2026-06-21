variable "do_token" {
  type        = string
  description = "Your secret DigitalOcean Personal Access Token"
  sensitive   = true
}

variable "local_private_key_path" {
  type        = string
  description = "Path to the local private SSH key for secure file transfers. Kept out of source control."
}

variable "ssh_public_key" {
  type        = string
  description = "The public SSH key used to register with DigitalOcean"
}

variable "db_user" {
  type        = string
  description = "Database user lookup for the root level"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password lookup for the root level"
}

variable "db_name" {
  type        = string
  description = "The name of the WordPress database"
}

variable "db_root_password" {
  type        = string
  sensitive   = true
  description = "The master root password for the MariaDB instance"
}

# --- Hardware variables declared at root level to stop main.tf errors ---
variable "droplet_image" {
  type    = string
  default = "ubuntu-24-04-x64"
}

variable "droplet_name" {
  type    = string
  default = "wp-portfolio-droplet"
}

variable "droplet_region" {
  type    = string
  default = "nyc3"
}

variable "droplet_size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "ssh_key_ids" {
  type    = list(string)
  default = []
}

# =====================================================================
# NEW ADDITION: Secure Access Tracking
# =====================================================================
variable "my_admin_ip" {
  type        = string
  description = "Dynamic management IP used to whitelist administrative SSH connection requests"
}

