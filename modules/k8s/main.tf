resource "yandex_kubernetes_cluster" "this" {
  name        = var.name
  description = "description"

  network_id = var.network_id

  master {
    version = var.version_k8s
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

  service_account_id      = yandex_iam_service_account.this_sa.id
  node_service_account_id = yandex_iam_service_account.this_node_sa.id

  labels = {
    my_key       = "my_value"
    my_other_key = "my_other_value"
  }

  release_channel         = "REGULAR"
  network_policy_provider = "CALICO"

  #   kms_provider {
  #     key_id = yandex_kms_symmetric_key.kubernetes_dev.id
  #   }
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.this_sa,
    yandex_resourcemanager_folder_iam_binding.this_node_sa
  ]
}
