## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать bucket Object Storage и разместить там файл с картинкой:
- Создать bucket в Object Storage с произвольным именем (например, _имя_студента_дата_);
- Положить в bucket файл с картинкой;
- Сделать файл доступным из Интернет.
```terraform
resource "yandex_storage_bucket" "my-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-netology-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-netology-static-key.secret_key
  bucket = "netology.jkkoaqsqcfpkmswl"
  acl    = "public-read" 
}

resource "yandex_storage_object" "ya-logo" {
  access_key = yandex_iam_service_account_static_access_key.sa-netology-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-netology-static-key.secret_key
  bucket = yandex_storage_bucket.my-bucket.bucket
  key    = "ya-logo.png"
  source = "img/15.2-1.png"
}
```
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и web-страничкой, содержащей ссылку на картинку из bucket:
- Создать Instance Group с 3 ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`;
- Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata);
- Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из bucket;
- Настроить проверку состояния ВМ.
```
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
```
3. Подключить группу к сетевому балансировщику:
- Создать сетевой балансировщик;
- Проверить работоспособность, удалив одну или несколько ВМ.
```terraform
resource "yandex_lb_network_load_balancer" "ig-load-balancer" {
  name = "ig-load-balancer"

  listener {
    name = "ig-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ws-group.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
       port = 80
      }
    }
  }
}
```