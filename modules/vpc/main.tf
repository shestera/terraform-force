resource "yandex_vpc_network" "this" {
  name        = var.name
  description = "${var.description} ${var.name} network"

  labels = var.labels
}

resource "yandex_vpc_subnet" "this" {
  for_each       = { for z in var.subnets : z.zone => z }
  name           = "${var.name}-${each.value.zone}"
  description    = "${var.description} ${var.name} subnet for zone ${each.value.zone}"
  v4_cidr_blocks = each.value.v4_cidr_blocks
  zone           = each.value.zone
  network_id     = yandex_vpc_network.this.id

  labels = var.labels
}