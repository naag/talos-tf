# Upload a custom image to DigitalOcean
resource "digitalocean_custom_image" "talos_custom_image" {
  name         = "talos-linux-${var.talos_version}"
  url          = "https://github.com/siderolabs/talos/releases/download/${var.talos_version}/digital-ocean-amd64.raw.gz"
  distribution = "Unknown OS"
  regions      = ["${var.do_region}"]
}

# Create a fake SSH key as DigitalOcean requires one
resource "tls_private_key" "fake_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "digitalocean_ssh_key" "fake_ssh_key" {
  name       = "${var.cluster_name}-fake-ssh-key"
  public_key = tls_private_key.fake_ssh_key.public_key_openssh
}

resource "digitalocean_loadbalancer" "talos_lb" {
  count = var.configure_talos ? 1 : 0

  name   = "${var.cluster_name}-k8s"
  region = var.do_region

  forwarding_rule {
    entry_port     = 6443
    entry_protocol = "tcp"

    target_port     = 6443
    target_protocol = "tcp"
  }

  healthcheck {
    port     = 50000
    protocol = "tcp"
  }

  droplet_ids = module.control_plane_nodes[*].droplet_id
}
