provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
}

module "vpc" {
  source = "./modules/vpc"

  name = "default"

  labels = {
    Role = "Network"
  }
}

module "openvpn" {
  source = "./modules/openvpn"

  subnet_id = module.vpc.subnets["ru-central1-a"].id

  labels = {
    Role = "Security"
  }
}

module "registry" {
  source = "./modules/registry"

  name = "default"

  labels = {
    Role = "Security"
  }
}

module "gitlab" {
  source = "./modules/gitlab"

  subnet_id = module.vpc.subnets["ru-central1-a"].id

  labels = {
    Role = "Development"
  }
}

module "gitlab_runner" {
  source = "./modules/gitlab-runner"

  subnet_id = module.vpc.subnets["ru-central1-a"].id
  folder_id = var.yandex_folder_id

  labels = {
    Role = "Development"
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
    Environment = "Development"
    Role        = "Database"
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
    Environment = "Development"
    Role        = "Application"
  }
}

module "k8s-ng" {
  source = "./modules/k8s-ng"

  name        = "ng-dev"
  cluster_id  = module.k8s.cluster_id
  version_k8s = "1.17"
  zone_id     = module.vpc.subnets["ru-central1-a"].zone

  labels = {
    Environment = "Development"
    Role        = "Application"
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