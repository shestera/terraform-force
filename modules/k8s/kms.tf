# resource "yandex_kms_symmetric_key" "this" {
#   name              = "kubernetes-${var.name}"
#   description       = "kms for for K8s cluster ${var.name}"
#   default_algorithm = var.kms_default_algorithm
# }