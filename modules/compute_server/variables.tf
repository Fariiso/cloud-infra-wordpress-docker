variable "droplet_image" {
  type        = string
  description = "The OS image to use for the droplet"
}

variable "droplet_name" {
  type        = string
  description = "The name of the droplet instance"
}

variable "droplet_region" {
  type        = string
  description = "The DigitalOcean region to deploy into"
}

variable "droplet_size" {
  type        = string
  description = "The slug representing the hardware size"
}

variable "ssh_key_ids" {
  type        = list(string)
  description = "List of SSH key IDs to embed in the droplet"
}

variable "private_key_path" {
  type        = string
  description = "The local absolute path to the private SSH key used for file transfers"
}

# Database variables received from the root level
variable "db_user" {
  type        = string
  description = "Receives db_user from root main.tf"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Receives db_password from root main.tf"
}

variable "db_name" {
  type        = string
  description = "Receives db_name from root main.tf"
}

variable "db_root_password" {
  type        = string
  sensitive   = true
  description = "Receives db_root_password from root main.tf"
}
