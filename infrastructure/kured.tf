resource "helm_release" "kured" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  
  name              = "kured"
  repository        = "https://weaveworks.github.io/kured/"
  chart             = "kured"
  namespace         = "kured-system"
  create_namespace  = true

}