data "talos_machine_configuration" "config" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = var.cluster_endpoint
  machine_type       = var.machine_type
  machine_secrets    = var.machine_secrets.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
  config_patches     = var.config_patches
}

resource "talos_machine_configuration_apply" "cp_config_apply" {
  client_configuration        = var.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.config.machine_configuration
  node                        = var.node
}
