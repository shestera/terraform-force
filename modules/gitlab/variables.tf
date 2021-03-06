variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "gitlab"
}

variable "subnet_id" {
  type = string
}

variable "subnet_zone" {
  type = string
}

variable "labels" {
  description = "A set of key/value label pairs to assign."

  type = map(string)

  default = {}
}

variable "user_data" {
  type    = string
  default = null
}