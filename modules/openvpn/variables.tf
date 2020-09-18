variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "openvpn"
}

variable "subnet_id" {
  type = string
}

variable "labels" {
  description = "A set of key/value label pairs to assign."

  type = map(string)

  default = {}
}