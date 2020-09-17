resource "yandex_kubernetes_cluster" "this" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id
  network_id  = var.network_id
  release_channel         = var.release_channel
  network_policy_provider = var.network_policy_provider
  service_account_id      = yandex_iam_service_account.this_sa.id
  node_service_account_id = yandex_iam_service_account.this_node_sa.id

  labels = var.labels

  master {
    version = var.master_version
    zonal {
      zone      = var.zone_id
      subnet_id = var.subnet_id
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

  dynamic "kms_provider" {
    for_each = var.kms_provider_key_id == null ? [] : [var.kms_provider_key_id]

    content {
      key_id = kms_provider.value
    }
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.this_sa,
    yandex_resourcemanager_folder_iam_binding.this_node_sa
  ]
}
