# TODO: Переделать на packer с готовой установкой gitlab или на docker-compose
data "yandex_compute_image" "this" {
  family = "ubuntu-1804-lts"
}

# TODO: Переделать на instance group
resource "yandex_compute_instance" "this" {
  name               = var.name
  zone               = var.subnet_zone
  service_account_id = yandex_iam_service_account.this.id

  labels = var.labels

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.this.id
      size     = 60
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    "user-data" : var.user_data
  }
}