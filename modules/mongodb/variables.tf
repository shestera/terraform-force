variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "mongodb"
}

variable "version" {
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