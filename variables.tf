variable "cluster_name" {
  description = "Name of cluster"
  type        = string
  default     = "talos-do"
}

variable "num_control_plane" {
  description = "Number of control plane nodes to create"
  type        = number
  default     = 3
}

variable "num_workers" {
  description = "Number of worker nodes to create"
  type        = number
  default     = 1
}

variable "configure_talos" {
  type    = bool
  default = true
}

variable "talos_version" {
  description = "Talos version to deploy"
  type        = string
  default     = "v1.5.3"
}

variable "kubernetes_version" {
  type    = string
  default = "1.28.3"
}

variable "do_region" {
  description = "DO region to use"
  type        = string
  default     = "nyc1"
}

variable "do_plan_control_plane" {
  description = "DO plan to use for control plane nodes"
  type        = string
  default     = "s-2vcpu-4gb"
}

variable "do_plan_worker" {
  description = "DO plan to use for worker nodes"
  type        = string
  default     = "s-2vcpu-4gb"
}
