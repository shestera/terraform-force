resource "yandex_iam_service_account" "k8s_sa_dev" {
  name        = "k8s-sa-dev"
  description = "Service account for K8s cluster dev"
  folder_id   = local.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_sa_dev" {
  folder_id = local.folder_id
  role      = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_sa_dev.id}"
  ]

  depends_on = [
    yandex_iam_service_account.k8s_sa_dev,
  ]
}

resource "yandex_iam_service_account" "k8s_node_sa_dev" {
  name        = "k8s-node-sa-dev"
  description = "Service account for K8s cluster dev"
  folder_id   = local.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_node_sa_dev" {
  folder_id = local.folder_id
  role      = "container-registry.images.puller"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_node_sa_dev.id}"
  ]

  depends_on = [
    yandex_iam_service_account.k8s_node_sa_dev,
  ]
}

resource "yandex_kms_symmetric_key" "kubernetes_dev" {
  name              = "kubernetes-dev"
  description       = "kms for dev kubernetes"
  default_algorithm = "AES_256"
}

resource "yandex_kubernetes_cluster" "dev" {
  name        = "dev"
  description = "description"

  network_id = yandex_vpc_network.default.id

  master {
    version = "1.17"
    zonal {
      zone      = yandex_vpc_subnet.default_ru_central1_a.zone
      subnet_id = yandex_vpc_subnet.default_ru_central1_a.id
    }

    public_ip = false

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.k8s_sa_dev.id
  node_service_account_id = yandex_iam_service_account.k8s_node_sa_dev.id

  labels = {
    my_key       = "my_value"
    my_other_key = "my_other_value"
  }

  release_channel         = "REGULAR"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = yandex_kms_symmetric_key.kubernetes_dev.id
  }
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.k8s_sa_dev,
    yandex_resourcemanager_folder_iam_binding.k8s_node_sa_dev
  ]
}

resource "yandex_kubernetes_node_group" "dev_node_group" {
  cluster_id  = yandex_kubernetes_cluster.dev.id
  name        = "dev-node-group"
  description = "description"
  version     = "1.17"

  labels = {
    "key" = "value"
  }

  instance_template {
    platform_id = "standard-v2"

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}