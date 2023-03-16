variable "folder_id" {
  type    = string
  default = "b1grtf5annaj45kv1e3p"
}

resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s-subnet1" {
  name           = "k8s-subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.terraform-network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

module "ya_instance_1" {
  source         = "./modules/instance"
  instance_image = "debian"
  instance_name  = "ya-instance-1"
  zone_id        = yandex_vpc_subnet.subnet1.zone
  subnet_id      = yandex_vpc_subnet.subnet1.id
}

resource "yandex_iam_service_account" "sa" {
  name = "niardan"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static key for object storage"
}

resource "yandex_storage_bucket" "remote-niardan-state-storage" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "remote-niardan-state-storage"
}