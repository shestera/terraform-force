variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "description" {
  description = "A description of the Kubernetes cluster."

  type = string

  default = null
}

variable "folder_id" {
  description = "The ID of the folder that the Kubernetes cluster belongs to."

  type = string
}

variable "network_id" {
  description = "The ID of the cluster network."

  type = string
}

variable "zone_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "master_version" {
  type = string
}

variable "kms_provider_key_id" {
  description = "KMS key ID."

  default = null
}

variable "release_channel" {
  description = "Cluster release channel. Possible values: RAPID, REGULAR, STABLE."
  type        = string
  default     = "REGULAR"

  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE"], var.release_channel)
    error_message = "Possible values: RAPID, REGULAR, STABLE."
  }
}

variable "network_policy_provider" {
  description = "Network policy provider for the cluster. Possible values: CALICO."
  type        = string
  default     = "CALICO"

  validation {
    condition     = contains(["CALICO"], var.network_policy_provider)
    error_message = "Possible values: CALICO."
  }
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the Kubernetes cluster."

  type = map(string)

  default = {}
}