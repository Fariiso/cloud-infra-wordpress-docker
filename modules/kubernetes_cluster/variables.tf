# modules/kubernetes_cluster/variables.tf

variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster"
  default     = "github-edu-k8s-cluster"
}

variable "region" {
  type        = string
  description = "DigitalOcean region to deploy the cluster"
  default     = "nyc3"
}

variable "node_count" {
  type        = number
  description = "Number of worker nodes in the pool"
  default     = 2
}