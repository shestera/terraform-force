resource "yandex_iam_service_account" "this_sa" {
  name        = "k8s-sa-${var.name}"
  description = "Service account for K8s cluster ${var.name}"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "this_sa" {
  folder_id = var.folder_id
  role      = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.this_sa.id}"
  ]

  depends_on = [
    yandex_iam_service_account.this_sa,
  ]
}

resource "yandex_iam_service_account" "this_node_sa" {
  name        = "k8s-node-sa-${var.name}"
  description = "Service account for K8s cluster ${var.name}"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "this_node_sa" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"

  members = [
    "serviceAccount:${yandex_iam_service_account.this_node_sa.id}"
  ]

  depends_on = [
    yandex_iam_service_account.this_node_sa,
  ]
}