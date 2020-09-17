resource "yandex_iam_service_account" "this" {
  name        = "gitlab-runner"
  description = "Service account for gitlab runner"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "this_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"

  members = [
    "serviceAccount:${yandex_iam_service_account.this.id}"
  ]

  depends_on = [
    yandex_iam_service_account.this,
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "this_pusher" {
  folder_id = var.folder_id
  role      = "container-registry.images.pusher"

  members = [
    "serviceAccount:${yandex_iam_service_account.this.id}"
  ]

  depends_on = [
    yandex_iam_service_account.this,
  ]
}