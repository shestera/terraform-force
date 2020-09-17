resource "random_string" "mongo-password" {
  length  = 16
  special = false
}

resource "yandex_mdb_mongodb_cluster" "dev" {
  name        = "dev"
  environment = "PRODUCTION"
  network_id  = module.vpc.network_id.id

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
    zone_id   = module.vpc.subnets["ru-central1-a"].zone
    subnet_id = module.vpc.subnets["ru-central1-a"].id
  }
}