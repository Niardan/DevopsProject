variable "instance_name" {
  description = "Instance name"
  type        = string
  default     = "lamp"
}

variable "instance_image" {
  description = "Instance image"
  type        = string
}

variable "subnet_id" {
  description = "VPC subnet network id"
  type        = string
}

variable "zone_id" {
  description = "Instance create zone"
  type        = string
}