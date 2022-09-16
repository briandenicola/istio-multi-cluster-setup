resource "helm_release" "cert-manager" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  
  name              = "cert-manager"
  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager"
  namespace         = "cert-manager"
  create_namespace  = true
  skip_crds         = false
  version           = "v1.9.1"

  set {
    name            = "installCRDs"
    value           = true
  }
}

/*
resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio-csr" {
  depends_on = [
    azurerm_kubernetes_cluster.this,
    kubernetes_namespace.istio-system,
    helm_release.cert-manager
  ]
  
  name              = "cert-manager-istio-csr"
  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager-istio-csr"
  namespace         = "cert-manager"
  create_namespace  = true
  skip_crds         = false
  version           = "v0.5.0"

  values = [
    "${file("istio-csr-values.yaml")}"
  ]
}*/