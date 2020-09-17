# TODO: Переделать на packer с готовой установкой gitlab или на docker-compose
data "yandex_compute_image" "ubuntu_gitlab" {
  family = "ubuntu-1804-lts"
}

resource "yandex_compute_instance" "gitlab" {
  name = "gitlab"

  resources {
    cores  = 1
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_gitlab.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_ru_central1_a.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_iam_service_account" "gitlab_runner" {
  name        = "gitlab-runner"
  description = "Service account for gitlab runner"
  folder_id   = local.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "gitlab_runner_puller" {
  folder_id = local.folder_id
  role      = "container-registry.images.puller"

  members = [
    "serviceAccount:${yandex_iam_service_account.gitlab_runner.id}"
  ]

  depends_on = [
    yandex_iam_service_account.gitlab_runner,
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "gitlab_runner_pusher" {
  folder_id = local.folder_id
  role      = "container-registry.images.pusher"

  members = [
    "serviceAccount:${yandex_iam_service_account.gitlab_runner.id}"
  ]

  depends_on = [
    yandex_iam_service_account.gitlab_runner,
  ]
}

# TODO: Переделать на instance group
resource "yandex_compute_instance" "gitlab-runner" {
  name = "gitlab-runner"

  resources {
    cores  = 1
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_gitlab.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_ru_central1_a.id
  }

  service_account_id = yandex_iam_service_account.gitlab_runner.id

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}