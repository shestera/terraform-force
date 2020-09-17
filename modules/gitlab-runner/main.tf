# TODO: Переделать на packer с готовой установкой gitlab или на docker-compose
data "yandex_compute_image" "this" {
  family = "ubuntu-1804-lts"
}

# TODO: Переделать на instance group
resource "yandex_compute_instance" "this" {
  name = var.name

  resources {
    cores  = 1
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.this.id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
  }

  service_account_id = yandex_iam_service_account.this.id

  # metadata = {
  #   ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  # }
}