locals {
  cloud_id    = "b1gsb0d7fuqaa40uciht"
  folder_id   = "b1grtf5annaj45kv1e3p"
  k8s_version = "1.22"
  sa_name     = "kuber"
}

provider "yandex" {
  folder_id = local.folder_id
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.60.0"
    }
  }
  required_version = ">= 0.13"
}
