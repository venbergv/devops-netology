locals {
  instance_type = {
    stage = "5"
    prod  = "20"
  }
}

locals {
  instance_count = {
    stage = 1
    prod = 2
  }
}

resource "yandex_compute_instance" "node" {
  name                      = "node0${count.index+1}-${terraform.workspace}"
  zone                      = "ru-central1-a"
  hostname                  = "node0${count.index+1}.netology.yc"
  platform_id               = "standard-v1"
  allow_stopping_for_update = true
  count                     = local.instance_count[terraform.workspace]

  resources {
    cores         = 2
    memory        = 2
    core_fraction = local.instance_type[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id    = var.ubuntu-latest
      name        = "root-node0${count.index+1}"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}


locals {
  instance_for_each = {
    stage = 1
    prod  = 2
  }
}

resource "yandex_compute_instance" "node_for_each" {
  for_each                  = local.instance_for_each
  name                      = "node0${each.value}-${terraform.workspace}-for_each"
  zone                      = "ru-central1-a"
  hostname                  = "node0${each.value}.netology.yc"
  platform_id               = "standard-v1"
  allow_stopping_for_update = true

  lifecycle {
    create_before_destroy = true
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = local.instance_type[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id    = var.ubuntu-latest
      name        = "root-node0${each.value}"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}
