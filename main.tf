# Bring up the control plane

module "control_plane_nodes" {
  source = "./modules/vm"

  count         = var.num_control_plane
  name          = "${var.cluster_name}-control-plane-${count.index}"
  region        = var.do_region
  instance_type = var.do_plan_control_plane
  image_id      = digitalocean_custom_image.talos_custom_image.id
  ssh_key_id    = digitalocean_ssh_key.fake_ssh_key.id
}

module "control_plane_talos" {
  source = "./modules/talos-machine"
  count  = var.configure_talos ? length(module.control_plane_nodes) : 0

  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${digitalocean_loadbalancer.talos_lb[0].ip}:6443"
  machine_type       = "controlplane"
  config_patches     = [local.talos_config_patch]
  machine_secrets    = talos_machine_secrets.machine_secrets
  node               = module.control_plane_nodes[count.index].ipv4_address
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
}

resource "talos_machine_bootstrap" "bootstrap" {
  count = var.configure_talos && length(module.control_plane_nodes) >= 1 ? 1 : 0

  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = module.control_plane_nodes[0].ipv4_address

  depends_on = [
    module.control_plane_talos
  ]
}

# Bring up the worker nodes

module "worker_nodes" {
  source = "./modules/vm"

  count         = var.num_workers
  name          = "${var.cluster_name}-worker-${count.index}"
  region        = var.do_region
  instance_type = var.do_plan_worker
  image_id      = digitalocean_custom_image.talos_custom_image.id
  ssh_key_id    = digitalocean_ssh_key.fake_ssh_key.id
}

module "worker_talos" {
  source = "./modules/talos-machine"
  count  = var.configure_talos ? length(module.worker_nodes) : 0

  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${digitalocean_loadbalancer.talos_lb[0].ip}:6443"
  machine_type       = "worker"
  config_patches     = [local.talos_config_patch]
  machine_secrets    = talos_machine_secrets.machine_secrets
  node               = module.worker_nodes[count.index].ipv4_address
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
}

resource "talos_machine_secrets" "machine_secrets" {
  talos_version = var.talos_version
}
