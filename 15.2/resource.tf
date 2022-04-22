
# resource "yandex_compute_instance" "web-server" {

#   count = 1

#   name     = "ws${count.index}"
#   hostname = "ws${count.index}"

#   resources {
#     cores         = 2
#     memory        = 1
#     core_fraction = 5
#   }

#   network_interface {
#     subnet_id = yandex_vpc_subnet.public.id
#     nat       = true
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "fd832gltdaeepe0m2hi8" # LAMP
#       size     = 10
#     }
#   }

#   scheduling_policy {
#     preemptible = true
#   }

#   metadata = {
#     ssh-keys = "ubuntu:${var.public_key}"
#   }

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     host        = self.network_interface.0.nat_ip_address
#     private_key = file("/home/user/.ssh/id_rsa")

#   }

#   provisioner "remote-exec" {
#     inline = ["sudo chmod 777 /var/www/html/index.html"]
#   }

#   provisioner "remote-exec" {
#     inline = ["echo '<html><head><title>Netology</title></head><body><h1>Netology</h1><p>${self.hostname}::${self.network_interface.0.nat_ip_address}</p><p><a href='https://storage.yandexcloud.net/${yandex_storage_bucket.my-bucket.bucket}/${yandex_storage_object.ya-logo.key}'>yandex logo</a></p></body></html>' > /var/www/html/index.html"]
#   }
# }