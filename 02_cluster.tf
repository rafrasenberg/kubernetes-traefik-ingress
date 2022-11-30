variable "cluster_name" {
  type        = string
  description = "Cluster name that will be created."
}
variable "cluster_region" {
  type        = string
  description = "Cluster region."
}
variable "cluster_tags" {
  type        = list(string)
  description = "Cluster tags."
}
variable "node_size" {
  type        = string
  description = "The size of the nodes in the cluster."
}
variable "node_max_count" {
  type        = number
  description = "Maximum amount of nodes in the cluster."
}
variable "node_min_count" {
  type        = number
  description = "Minimum amount of nodes in the cluster."
}

data "digitalocean_kubernetes_versions" "do_cluster_version" {
  version_prefix = "1.24."
}

resource "digitalocean_kubernetes_cluster" "do_cluster" {
  name         = var.cluster_name
  region       = var.cluster_region
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.do_cluster_version.latest_version
  tags         = var.cluster_tags

  node_pool {
    name       = "${var.cluster_name}-pool"
    size       = var.node_size
    min_nodes  = var.node_min_count
    max_nodes  = var.node_max_count
    auto_scale = true
  }
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.do_cluster.endpoint
  token = digitalocean_kubernetes_cluster.do_cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.do_cluster.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.do_cluster.endpoint
    token = digitalocean_kubernetes_cluster.do_cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.do_cluster.kube_config[0].cluster_ca_certificate
    )
  }
}