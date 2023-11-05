data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = module.control_plane_nodes[*].ipv4_address
  nodes                = concat(module.control_plane_nodes[*].ipv4_address, module.worker_nodes[*].ipv4_address)
}

resource "local_file" "talos_cfg" {
  filename = "${path.module}/config/talos.cfg"
  content  = nonsensitive(data.talos_client_configuration.talosconfig.talos_config)
}

data "talos_cluster_kubeconfig" "kubeconfig" {
  count = var.configure_talos ? 1 : 0

  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = module.control_plane_nodes[0].ipv4_address

  depends_on = [
    talos_machine_bootstrap.bootstrap
  ]
}

resource "local_file" "kube_cfg" {
  count = var.configure_talos ? 1 : 0

  filename = "${path.module}/config/kube.cfg"
  content  = nonsensitive(data.talos_cluster_kubeconfig.kubeconfig[0].kubeconfig_raw)
}
