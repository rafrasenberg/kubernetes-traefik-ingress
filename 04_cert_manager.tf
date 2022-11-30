variable "cert_manager_chart_name" {
  type        = string
  description = "Cert Manager Helm name."
}
variable "cert_manager_chart_repo" {
  type        = string
  description = "Cert Manager Helm repository name."
}
variable "cert_manager_chart_version" {
  type        = string
  description = "Cert Manager Helm version."
}

resource "kubernetes_namespace" "cert_manager_namespace" {
  metadata {
    annotations = {
      name = "cert-manager"
    }
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  chart      = var.cert_manager_chart_name
  repository = var.cert_manager_chart_repo
  version    = var.cert_manager_chart_version

  set {
    name  = "installCRDs"
    value = "true"
  }
}