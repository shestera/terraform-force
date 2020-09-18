resource "yandex_container_registry" "this" {
  name = var.name

  labels = var.labels
}
# TODO: lifecycle-policy 