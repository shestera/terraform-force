resource "yandex_container_registry" "this" {
  name = var.name
}
# TODO: lifecycle-policy 