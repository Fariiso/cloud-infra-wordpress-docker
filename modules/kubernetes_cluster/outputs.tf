# modules/kubernetes_cluster/outputs.tf

output "cluster_id" {
  value = digitalocean_kubernetes_cluster.doks.id
}

output "kube_config" {
  value     = digitalocean_kubernetes_cluster.doks.kube_config[0].raw_config
  sensitive = true
}