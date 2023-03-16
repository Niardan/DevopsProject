resource "yandex_kubernetes_node_group" "k8s-node-group" {
  cluster_id  = yandex_kubernetes_cluster.k8s-zonal.id
  name        = "k8s-node-group"
  description = "work node"
  version     = local.k8s_version
  depends_on = [
    yandex_kubernetes_cluster.k8s-zonal
  ]

  instance_template {
    platform_id = "standard-v2"
    metadata = {
      ssh-key = file("~/.ssh/id_rsa.pub")
    }
    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.mysubnet.id}"]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
