# Сервисный аккаунт для кластера Kubernetes
resource "yandex_iam_service_account" "k8s_cluster_sa" {
  name        = "k8s-cluster-sa"
  description = "Service account for Kubernetes control plane"
  folder_id   = "b1g2tat8ebtm1fhmfe8l"
}

# Сервисный аккаунт для нод Kubernetes
resource "yandex_iam_service_account" "k8s_node_sa" {
  name        = "k8s-node-sa"
  description = "Service account for Kubernetes worker nodes"
  folder_id   = "b1g2tat8ebtm1fhmfe8l"
}
