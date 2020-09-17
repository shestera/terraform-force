provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
}

module "vpc" {
  source = "./modules/vpc"

  name = "default"
}

module "openvpn" {
  source = "./modules/openvpn"

  subnet_id = module.vpc.subnets["ru-central1-a"].id
}

module "registry" {
  source = "./modules/registry"

  name = "default"
}

module "gitlab" {
  source = "./modules/gitlab"

  subnet_id = module.vpc.subnets["ru-central1-a"].id
}

module "gitlab_runner" {
  source = "./modules/gitlab-runner"

  subnet_id = module.vpc.subnets["ru-central1-a"].id
  folder_id = var.yandex_folder_id
}

module "mongodb" {
  source = "./modules/mongodb"

  name            = "dev"
  version_mongodb = "4.2"
  network_id      = module.vpc.network_id
  zone_id         = module.vpc.subnets["ru-central1-a"].zone
  subnet_id       = module.vpc.subnets["ru-central1-a"].id
}

module "k8s" {
  source = "./modules/k8s"

  name        = "dev"
  master_version = "1.17"
  folder_id   = var.yandex_folder_id
  network_id  = module.vpc.network_id
  zone_id     = module.vpc.subnets["ru-central1-a"].zone
  subnet_id   = module.vpc.subnets["ru-central1-a"].id
  # kms_provider_key_name = "k8s-dev"

  # labels = {
  #   my_key       = "my_value"
  #   my_other_key = "my_other_value"
  # }
}

module "k8s-ng" {
  source = "./modules/k8s-ng"

  name        = "ng-dev"
  cluster_id  = module.k8s.cluster_id
  version_k8s = "1.17"
  zone_id     = module.vpc.subnets["ru-central1-a"].zone
}