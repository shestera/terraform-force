provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
}

module "vpc" {
  source  = "shestera/vpc/yandex"
  version = "0.1.0"

  name = "default"

  labels = {
    role = "network"
  }
}

module "openvpn" {
  source = "./modules/openvpn"

  subnet_id = module.vpc.subnets["ru-central1-a"].id
  user_data = file("cloud-config.conf")

  labels = {
    role = "security"
  }
}

module "registry" {
  source  = "shestera/registry/yandex"
  version = "0.0.1"

  name = "default"

  labels = {
    role = "security"
  }
}

module "gitlab" {
  source = "./modules/gitlab"

  subnet_id = module.vpc.subnets["ru-central1-a"].id
  user_data = file("cloud-config.conf")

  labels = {
    role = "development"
  }
}

module "gitlab_runner" {
  source = "./modules/gitlab-runner"

  subnet_id = module.vpc.subnets["ru-central1-a"].id
  folder_id = var.yandex_folder_id
  user_data = file("cloud-config.conf")

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


# provider "helm" {
#   kubernetes {
#     load_config_file = false

#     host = module.cluster.external_v4_endpoint
#     cluster_ca_certificate = module.cluster.ca_certificate
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command = "${path.root}/yc-cli/bin/yc"
#       args = [
#         "managed-kubernetes",
#         "create-token",
#         "--cloud-id", var.yandex_cloud_id,
#         "--folder-id", var.yandex_folder_id,
#         "--token", var.yandex_token,
#       ]
#     }
#   }
# }

# provider "kubernetes" {
#   load_config_file = false

#   host = module.cluster.external_v4_endpoint
#   cluster_ca_certificate = module.cluster.ca_certificate
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command = "${path.root}/yc-cli/bin/yc"
#     args = [
#       "managed-kubernetes",
#       "create-token",
#       "--cloud-id", var.yandex_cloud_id,
#       "--folder-id", var.yandex_folder_id,
#       "--token", var.yandex_token,
#     ]
#   }
# }

# module "nginx-ingress" {
#   source = "./modules/nginx-ingress"

#   version_nginx_ingress = "1.26.1"
# }