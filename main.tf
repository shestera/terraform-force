provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
}

module "vpc" {
  source  = "shestera/vpc/yandex"
  version = "0.3.0"

  name         = "default"
  nat_instance = false

  labels = {
    role = "network"
  }
}

# module "openvpn" {
#   source = "./modules/openvpn"

#   subnet_id = module.vpc.subnets["ru-central1-a"].id
#   subnet_zone = module.vpc.subnets["ru-central1-a"].zone
#   user_data = file("cloud-config.conf")

#   labels = {
#     role = "security"
#   }
# }

module "registry" {
  source  = "shestera/registry/yandex"
  version = "0.1.0"

  name = "default"

  labels = {
    role = "security"
  }
}

module "gitlab" {
  source = "./modules/gitlab"

  subnet_id   = module.vpc.subnets["ru-central1-a"].id
  subnet_zone = module.vpc.subnets["ru-central1-a"].zone
  user_data   = file("cloud-config.conf")

  labels = {
    role = "development"
  }
}

module "gitlab_runner" {
  source = "./modules/gitlab-runner"

  subnet_id   = module.vpc.subnets["ru-central1-a"].id
  subnet_zone = module.vpc.subnets["ru-central1-a"].zone
  folder_id   = var.yandex_folder_id
  user_data   = file("cloud-config.conf")

  labels = {
    role = "development"
  }
}

module "mongodb" {
  source = "./modules/mongodb"

  name            = "dev"
  version_mongodb = "4.2"
  network_id      = module.vpc.network_id
  zone_id         = module.vpc.subnets["ru-central1-a"].zone
  subnet_id       = module.vpc.subnets["ru-central1-a"].id

  labels = {
    environment = "development"
    role        = "database"
  }
}

module "k8s" {
  source = "./modules/k8s"

  name           = "dev"
  master_version = "1.17"
  folder_id      = var.yandex_folder_id
  network_id     = module.vpc.network_id
  zone_id        = module.vpc.subnets["ru-central1-a"].zone
  subnet_id      = module.vpc.subnets["ru-central1-a"].id

  labels = {
    environment = "development"
    role        = "application"
  }
}

module "k8s-ng" {
  source = "./modules/k8s-ng"

  name        = "ng-dev"
  cluster_id  = module.k8s.cluster_id
  version_k8s = "1.17"
  zone_id     = module.vpc.subnets["ru-central1-a"].zone

  labels = {
    environment = "development"
    role        = "application"
  }
}
