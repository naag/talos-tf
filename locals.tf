locals {
  talos_config_patch = yamlencode({
    machine = {
      network = {
        kubespan = {
          enabled = true
        }
      }
      features = {
        kubePrism = {
          enabled = true
          port    = 7445
        }
      }
    }
  })
}
