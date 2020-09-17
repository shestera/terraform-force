# TODO: Переделать на packer с готовой установкой gitlab или на docker-compose
data "yandex_compute_image" "ubuntu_openvpn" {
  family = "ubuntu-1804-lts"
}

resource "yandex_compute_instance" "openvpn" {
  name = "gitlab"

  resources {
    cores  = 1
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_openvpn.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_ru_central1_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}