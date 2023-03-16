data "yandex_compute_image" "server_image" {
  family = var.instance_image
}

resource "yandex_compute_instance" "vm-server" {
  name                      = "server-${var.instance_name}"
  allow_stopping_for_update = true
  zone                      = var.zone_id
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.server_image.id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
  }

  metadata = {
    ssh-key = file("~/.ssh/id_rsa.pub")
  }
}