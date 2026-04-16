terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  folder_id = "b1g2tat8ebtm1fhmfe8l"
  zone      = "ru-central1-a"
}
