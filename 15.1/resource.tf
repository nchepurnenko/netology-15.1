resource "yandex_compute_instance" "gw" {

  name     = "gw"
  hostname = "gw"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd85vbr6kin3r8ro2e95" # NAT instance
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    ip_address = "192.168.10.254"
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }
}

resource "yandex_compute_instance" "vm01_public" {

  name     = "vm01-public"
  hostname = "vm01-public"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8qqvji2rs2lehr7d1l" # ubuntu 20.04
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }
}

resource "yandex_compute_instance" "vm01_private" {

  name     = "vm01-private"
  hostname = "vm01-private"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8qqvji2rs2lehr7d1l" # ubuntu 20.04
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }
}
