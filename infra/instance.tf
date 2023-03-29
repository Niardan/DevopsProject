data "yandex_compute_image" "server_image" {
  family = "debian-11"
}

resource "yandex_compute_instance" "vm-server" {
  name                      = "vm-server"
  allow_stopping_for_update = true
  zone                      = yandex_vpc_subnet.mysubnet.zone
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.server_image.id
	  size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.mysubnet.id
	nat       = true
  }

  metadata = {
    ssh-keys = "debian:${file("~/.ssh/id_rsa.pub")}"
  }
}