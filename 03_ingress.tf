variable "ingress_gateway_chart_name" {
  type        = string
  description = "Ingress Gateway Helm chart name."
}
variable "ingress_gateway_chart_repo" {
  type        = string
  description = "Ingress Gateway Helm repository name."
}
variable "ingress_gateway_chart_version" {
  type        = string
  description = "Ingress Gateway Helm repository version."
}

resource "kubernetes_namespace" "ingress_gateway_namespace" {
  metadata {
    annotations = {
      name = "traefik"
    }
    name = "traefik"
  }
}

resource "helm_release" "ingress_gateway" {
  name       = "traefik"
  namespace  = "traefik"
  chart      = var.ingress_gateway_chart_name
  repository = var.ingress_gateway_chart_repo
  version    = var.ingress_gateway_chart_version

  values = [
    file("helm_values/traefik.yml")
  ]
}