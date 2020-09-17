variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "description" {
  description = "An optional description of this resource. Provide this property when you create the resource."
  type        = string
  default     = "Auto-created"
}

variable "subnets" {
  type = list(object({
    zone           = string
    v4_cidr_blocks = list(string)
  }))
  default = [
    {
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.130.0.0/24"]
    },
    {
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["10.129.0.0/24"]
    },
    {
      zone           = "ru-central1-c"
      v4_cidr_blocks = ["10.128.0.0/24"]
    }
  ]
}