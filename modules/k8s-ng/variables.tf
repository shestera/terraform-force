variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "cluster_id" {
  type = string
}

variable "version_k8s" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "labels" {
  description = "A set of key/value label pairs to assign."

  type = map(string)

  default = {}
}