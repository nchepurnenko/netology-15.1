resource "yandex_compute_instance_group" "ws-group" {
  name                = "ws-group"
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.sa-netology.id}"
  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 1
      cores  = 2
      core_fraction = 5
    }
    boot_disk {
        initialize_params {
        image_id = "fd832gltdaeepe0m2hi8" # LAMP
        size     = 10
        }
    }
    network_interface {
        subnet_ids = [ yandex_vpc_subnet.public.id ]
        nat       = true
    }

    scheduling_policy {
        preemptible = true
    }

    metadata = {
      user-data = "#cloud-config\nruncmd:\n  - sudo chmod 777 /var/www/html/index.html\n  - echo '<html><head><title>Netology</title></head><body><h1>Netology</h1><p><a href='https://storage.yandexcloud.net/${yandex_storage_bucket.my-bucket.bucket}/${yandex_storage_object.ya-logo.key}'>yandex logo</a></p></body></html>' > /var/www/html/index.html"
      ssh-keys = "ubuntu:${var.public_key}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }

  load_balancer {
    target_group_name        = "netology"
    target_group_description = "netology group"
  }
}