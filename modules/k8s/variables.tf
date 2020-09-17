variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "folder_id" {
  type = string
}

variable "network_id" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "version_k8s" {
  type = string
}

variable "kms_default_algorithm" {
  type    = string
  default = "AES_256"
}