output "network_id" {
  description = "The ID of the VPC"
  value       = yandex_vpc_network.this.id
}

output "subnet_ids" {
  value = values(yandex_vpc_subnet.this)[*].id
}

output "subnets" {
  value = { for v in yandex_vpc_subnet.this : v.zone => map(
    "id", v.id,
    "name", v.name,
    "zone", v.zone
  ) }
}