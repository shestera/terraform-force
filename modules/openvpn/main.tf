# TODO: Переделать на packer с готовой установкой openvpn 
data "yandex_compute_image" "this" {
  family = "ubuntu-1804-lts"
}

resource "yandex_compute_instance" "this" {
  name     = var.name
  hostname = var.name
  
  labels = var.labels

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
    nat       = true
  }

  metadata = {
    "user-data": var.user_data
  }
}