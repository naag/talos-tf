variable "node" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "machine_secrets" {
}

variable "talos_version" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "config_patches" {
  type = list(string)
}
