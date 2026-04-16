# Основная сеть
resource "yandex_vpc_network" "default" {
  name        = "default"
  description = "Auto-created network"
}

# Подсети
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "default-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.128.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "default-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.129.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_d" {
  name           = "default-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_e" {
  name           = "default-ru-central1-e"
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.131.0.0/24"]
}

# Подсети для Kubernetes (зарезервированные)
resource "yandex_vpc_subnet" "k8s_pod_cidr" {
  name           = "k8s-cluster-catp5jjtn9s42vcf9n7q-pod-cidr-reservation"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.112.0.0/16"]
  description    = "Reserved for Kubernetes pods"
}

resource "yandex_vpc_subnet" "k8s_service_cidr" {
  name           = "k8s-cluster-catp5jjtn9s42vcf9n7q-service-cidr-reservation"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.96.0.0/16"]
  description    = "Reserved for Kubernetes services"
}
