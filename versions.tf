terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.31.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.3.4"
    }
  }
}

provider "digitalocean" {}

provider "talos" {}
