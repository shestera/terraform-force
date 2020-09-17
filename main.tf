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

locals {
  folder_id = "<идентификатор каталога>"
}