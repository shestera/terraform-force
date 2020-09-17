variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "gitlab-runner"
}

variable "subnet_id" {
  type = string
}

variable "folder_id" {
  type = string
}