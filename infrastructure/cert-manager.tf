resource "helm_release" "cert_manager" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  name              = "jetstack"
  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager"
  namespace         = "cert-manager"
  create_namespace  = true
  version           = "v1.8.2"

  set {
    name  = "installCRDs"
    value = true
  }
}