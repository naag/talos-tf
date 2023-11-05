## Create all instances
resource "digitalocean_droplet" "this" {
  image    = var.image_id
  name     = var.name
  region   = var.region
  size     = var.instance_type
  ssh_keys = [var.ssh_key_id]
}
