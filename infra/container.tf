### container.tf
# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password.html. It will download "hashicorp/random" provider
resource "random_password" "container_root_password" {
  length           = 24
  override_special = "_%@"
  special          = true
}

output "container_root_password" {
  value     = random_password.container_root_password.result
  sensitive = true
}

# location of containers templates
resource "proxmox_virtual_environment_file" "debian_container_template" {
  content_type = "vztmpl"
  datastore_id = var.ct_datastore_template_location
  node_name    = "pve1"

  source_file {
    path = var.ct_source_file_path
  }
}

resource "proxmox_virtual_environment_container" "debian_container" {
  description   = "Managed by Terraform"
  node_name     = "pve1"
  start_on_boot = true
  tags          = ["linux", "infra"]
  unprivileged  = true
  vm_id         = 241001

  cpu {
    architecture = "amd64"
    cores        = 1
  }

  disk {
    datastore_id = var.ct_datastore_storage_location
    size         = var.ct_disk_size
  }

  memory {
    dedicated = var.ct_memory
    swap      = 0
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_file.debian_container_template.id
    type             = var.os_type
  }

  initialization {
    hostname = "ct-example"

    dns {
      domain = var.dns_domain
      server = var.dns_server
    }

    ip_config {
      ipv4 {
        address = "192.168.1.3/24"
        gateway = var.gateway
      }
    }
    user_account {
      keys     = ["put-your-ssh-pubkey-here"]
      password = random_password.container_root_password.result
    }
  }
  network_interface {
    name       = var.ct_bridge
    rate_limit = var.ct_nic_rate_limit
  }

  features {
    nesting = true
    fuse    = false
  }
}