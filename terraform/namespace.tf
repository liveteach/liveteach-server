resource "kubernetes_namespace" "app_namespace" {
  metadata {
    labels = {
      name = var.app_name
    }

    name = var.app_name
  }
}