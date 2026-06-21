output "droplet_id" {
  value       = digitalocean_droplet.web.id  # Make sure this matches your main.tf name!
  description = "The ID of the newly created Droplet server"
}
