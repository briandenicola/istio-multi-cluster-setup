resource "helm_release" "cert-manager" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  
  name              = "cert-manager"
  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager"
  namespace         = "cert-manager"
  create_namespace  = true

}

resource "helm_release" "istio-csr" {
  depends_on = [
    azurerm_kubernetes_cluster.this,
    helm_release.cert-manager
  ]
  
  name              = "cert-manager-istio-csr"
  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager-istio-csr"
  namespace         = "cert-manager"
  create_namespace  = true

  values = [
    "${file("istio-csr-values.yaml")}"
  ]
}