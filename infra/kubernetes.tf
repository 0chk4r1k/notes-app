# Infrastructure for Yandex Cloud Managed Service for Kubernetes cluster
#
# Set the configuration of Managed Service for Kubernetes cluster

locals {
  zone_a_v4_cidr_blocks = "10.1.0.0/16"   # CIDR для подсети в зоне ru-central1-a
  cluster_ipv4_cidr     = "10.112.0.0/16" # Диапазон IP для подов
  service_ipv4_cidr     = "10.96.0.0/16"  # Диапазон IP для сервисов
  folder_id             = "b1g2tat8ebtm1fhmfe8l" # Ваша папка
  k8s_version           = "1.32"          # Версия Kubernetes
  sa_name               = "k8s-sa-notes"  # Имя сервисного аккаунта
}

# Managed Service for Kubernetes cluster
resource "yandex_kubernetes_cluster" "notes" {
  description        = "Managed Service for Kubernetes cluster"
  name               = "notes-cluster"
  network_id         = yandex_vpc_network.default.id
  cluster_ipv4_range = local.cluster_ipv4_cidr
  service_ipv4_range = local.service_ipv4_cidr

  master {
    version = local.k8s_version
    master_location {
      zone      = yandex_vpc_subnet.subnet_a.zone
      subnet_id = yandex_vpc_subnet.subnet_a.id
    }

    public_ip = true

  }

  service_account_id      = yandex_iam_service_account.k8s_cluster_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_node_sa.id
}

resource "yandex_kubernetes_node_group" "notes-nodes" {
  description = "Node group for Managed Service for Kubernetes cluster"
  name        = "notes-nodes"
  cluster_id  = yandex_kubernetes_cluster.notes.id
  version     = local.k8s_version

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  instance_template {
    platform_id = "standard-v4a"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.subnet_a.id]
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }
  }
}
