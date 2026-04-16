# mysql-cluster.tf
# MySQL-кластер
resource "yandex_mdb_mysql_cluster" "notes_mysql" {
  name                = "notes-mysql"
  environment         = "PRODUCTION"
  network_id          = yandex_vpc_network.default.id
  version             = "8.0"
  security_group_ids  = []
  deletion_protection = false

  resources {
    resource_preset_id = "s4a-c2-m8"
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.subnet_a.id
    assign_public_ip = false
    priority         = 1
    backup_priority  = 1
  }
}

# Пользователь (с паролем из переменной)
resource "yandex_mdb_mysql_user" "notes_user" {
  cluster_id = yandex_mdb_mysql_cluster.notes_mysql.id
  name       = "notes_user"
  password   = var.mysql_user_password
}
