resource "yandex_mdb_mongodb_cluster" "dev" {
  name        = "dev"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.default.id

  cluster_config {
    version = "4.2"
  }

  labels = {
    test_key = "test_value"
  }

  database {
    name = "testdb"
  }

  user {
    name     = "john"
    password = "password"
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
    zone_id   = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.default_ru_central1_a.id
  }
}