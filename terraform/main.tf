locals {
  vms = {
    app-1    = { id = 201, cores = 2, mem = 2048, disk = 20 }
    app-2    = { id = 202, cores = 2, mem = 2048, disk = 20 }
    postgres = { id = 203, cores = 4, mem = 4096, disk = 40 }
    redis    = { id = 204, cores = 2, mem = 1024, disk = 10 }
    nginx    = { id = 205, cores = 2, mem = 1024, disk = 10 }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each  = local.vms
  name      = each.key
  node_name = var.pve_node
  vm_id     = each.value.id

  clone {
    vm_id = 9000
    full  = true
  }

  agent { enabled = true }

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.mem
  }

  disk {
    datastore_id = var.datastore
    interface    = "scsi0"
    size         = each.value.disk
    iothread     = true
    discard      = "on"
  }

  initialization {
    datastore_id = var.datastore
    ip_config {
      ipv4 {
        address = "192.168.0.${each.value.id}/24"
        gateway = var.gateway
      }
    }
    user_account {
      username = "estrela"
      keys     = [for p in var.ssh_pubkey_paths : trimspace(file(p))]
    }
  }
}
