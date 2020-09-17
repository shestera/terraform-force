resource "random_string" "mongo-password" {
  length  = 16
  special = false
}

resource "yandex_mdb_mongodb_cluster" "this" {
  name        = var.name
  environment = "PRODUCTION"
  network_id  = var.network_id

  cluster_config {
    version = var.version
  }

  labels = {
    test_key = "test_value"
  }

  database {
    name = "testdb"
  }

  user {
    name     = "user"
    password = random_string.mongo-password.result
    permission {
      database_name = "testdb"
    }
  }

  resources {
    resource_preset_id = "b2.micro"
    disk_size          = 16
    disk_type_id       = "network-hdd"
  }

  host {
    zone_id   = var.zone_id
    subnet_id = var.subnet_id
  }
}