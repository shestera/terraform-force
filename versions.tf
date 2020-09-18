terraform {
  required_providers {
    yandex = {
      source = "terraform-providers/yandex"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}
