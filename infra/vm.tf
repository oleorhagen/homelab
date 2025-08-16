# resource is formatted to be "[type]" "[entity_name]" so in this case
# we are looking to create a proxmox_vm_qemu entity named test_server

# resource "proxmox_virtual_environment_vm" "vm" {
#   node_name   = "pve"
#   vm_id       = 100
#   name        = "vm-example"
#   description = "Managed by Terraform"
#   tags        = ["terraform", "ubuntu"]
#   bios        = var.bios

#   # clone from the Ubuntu 24.04 template we created earlier
#   clone {
#     vm_id = 9024
#     full  = true
#   }

#   # keep the first disk as boot disk
#   disk {
#     datastore_id = "local-lvm"
#     interface    = "scsi0"
#     size         = 8
#     file_format  = "raw"
#     cache        = "writeback"
#     iothread     = false
#     ssd          = true
#     discard      = "on"
#   }

#   # create an EFI disk when the bios is set to ovmf
#   dynamic "efi_disk" {
#     for_each = (var.bios == "ovmf" ? [1] : [])
#     content {
#       datastore_id      = "local-lvm"
#       file_format       = "raw"
#       type              = "4m"
#       pre_enrolled_keys = true
#     }
#   }

#   network_device {
#     bridge  = "vmbr0"
#     vlan_id = "1"
#   }

#   # cloud-init config
#   initialization {
#     interface           = "ide2"
#     type                = "nocloud"
#     vendor_data_file_id = "local:snippets/vendor-data.yaml"
#     upgrade             = true

#     # add SSH key to cloud-init default user
#     user_account {
#       keys = [file("${var.ci_ssh_key}")]
#     }

#     ip_config {
#       ipv4 {
#         address = "dhcp"
#       }
#     }
#   }

#   # cloud-init SSH keys will cause a forced replacement, this is expected
#   # behavior see https://github.com/bpg/terraform-provider-proxmox/issues/373
#   lifecycle {
#     ignore_changes = [initialization["user_account"], ]
#   }
# }
import {
  to = proxmox_virtual_environment_container.postgresql-server-turnkey
  id = "pm1/102"
}

# proxmox_virtual_environment_container.postgresql-server-turnkey:
resource "proxmox_virtual_environment_container" "postgresql-server-turnkey" {
  description  = null
  id           = "102"
  ipv4         = {}
  ipv6         = {}
  node_name    = "pm1"
  protection   = false
  started      = true
  tags         = []
  template     = false
  unprivileged = true

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  disk {
    datastore_id = "local"
    size         = 8
  }

  initialization {
    hostname = "postgresql-server-turnkey"

    ip_config {
      ipv4 {
        address = "10.10.10.100/24"
        gateway = "10.10.10.1"
      }
    }
  }

  memory {
    dedicated = 1024
    swap      = 0
  }

  network_interface {
    bridge      = "vmbr0"
    enabled     = true
    firewall    = true
    mac_address = "BC:24:11:CF:B7:7C"
    mtu         = 0
    name        = "eth0"
    rate_limit  = 0
    vlan_id     = 0
  }

  operating_system {
    template_file_id = null
    type             = "debian"
  }
}

import {
  to = proxmox_virtual_environment_container.fileserver-turnkey
  id = "pm1/103"
}


# proxmox_virtual_environment_container.fileserver-turnkey:
resource "proxmox_virtual_environment_container" "fileserver-turnkey" {
  description  = "Fileserver NFS/SMB"
  id           = "103"
  ipv4         = {}
  ipv6         = {}
  node_name    = "pm1"
  protection   = false
  started      = true
  tags         = []
  template     = false
  unprivileged = true

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  disk {
    datastore_id = "local"
    size         = 8
  }

  initialization {
    hostname = "fileserver-turnkey"

    ip_config {
      ipv4 {
        address = "10.10.10.101/24"
        gateway = "10.10.10.1"
      }
    }
  }

  memory {
    dedicated = 512
    swap      = 512
  }

  network_interface {
    bridge      = "vmbr0"
    enabled     = true
    firewall    = true
    mac_address = "BC:24:11:C9:C4:A4"
    mtu         = 0
    name        = "eth0"
    rate_limit  = 0
    vlan_id     = 0
  }

  operating_system {
    template_file_id = null
    type             = "debian"
  }
}


import {
  to = proxmox_virtual_environment_container.pve-backup
  id = "pm1/104"
}

# proxmox_virtual_environment_container.pve-backup:
resource "proxmox_virtual_environment_container" "pve-backup" {
  description  = "backup server - external hard-drive"
  id           = "104"
  ipv4         = {}
  ipv6         = {}
  node_name    = "pm1"
  protection   = false
  started      = true
  tags         = []
  template     = false
  unprivileged = true

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  cpu {
    architecture = "amd64"
    cores        = 4
    units        = 1024
  }

  disk {
    datastore_id = "wddisk-lvm"
    size         = 100
  }

  initialization {
    hostname = "pve-backup"

    ip_config {
      ipv4 {
        address = "10.10.10.104/24"
        gateway = "10.10.10.1"
      }
    }
  }

  memory {
    dedicated = 4096
    swap      = 4096
  }

  network_interface {
    bridge      = "vmbr0"
    enabled     = true
    firewall    = true
    mac_address = "BC:24:11:D8:88:CE"
    mtu         = 0
    name        = "eth0"
    rate_limit  = 0
    vlan_id     = 0
  }

  operating_system {
    template_file_id = null
    type             = "debian"
  }
}


# proxmox_virtual_environment_vm.VM:
resource "proxmox_virtual_environment_vm" "VM" {
  acpi                    = true
  bios                    = "seabios"
  description             = null
  id                      = "100"
  ipv4_addresses          = []
  ipv6_addresses          = []
  keyboard_layout         = null
  kvm_arguments           = null
  mac_addresses           = []
  machine                 = null
  name                    = null
  network_interface_names = []
  node_name               = "pm1"
  protection              = false
  scsi_hardware           = "virtio-scsi-single"
  started                 = true
  tablet_device           = true
  tags = [
    "k8s",
    "orhagen.no",
  ]
  template = false
  vm_id    = 100

  cpu {
    affinity     = null
    architecture = null
    cores        = 2
    flags        = []
    hotplugged   = 0
    limit        = 0
    numa         = false
    sockets      = 1
    type         = "x86-64-v2-AES"
    units        = 1024
  }

  disk {
    aio               = "io_uring"
    backup            = true
    cache             = "none"
    datastore_id      = "local"
    discard           = "ignore"
    file_format       = "iso"
    file_id           = null
    import_from       = null
    interface         = "ide2"
    iothread          = false
    path_in_datastore = "iso/ubuntu-22.04.3-live-server-amd64.iso"
    replicate         = true
    serial            = null
    size              = 1
    ssd               = false
  }
  disk {
    aio               = "io_uring"
    backup            = true
    cache             = "none"
    datastore_id      = "local"
    discard           = "ignore"
    file_format       = "qcow2"
    file_id           = null
    import_from       = null
    interface         = "scsi0"
    iothread          = true
    path_in_datastore = "100/vm-100-disk-0.qcow2"
    replicate         = true
    serial            = null
    size              = 25
    ssd               = false
  }

  initialization {
    datastore_id         = "local"
    interface            = "ide0"
    meta_data_file_id    = null
    network_data_file_id = null
    type                 = null
    user_data_file_id    = null
    vendor_data_file_id  = null
  }

  memory {
    dedicated      = 8192
    floating       = 0
    hugepages      = null
    keep_hugepages = false
    shared         = 0
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    enabled      = true
    firewall     = true
    mac_address  = "BC:24:11:82:2A:BE"
    model        = "virtio"
    mtu          = 0
    queues       = 0
    rate_limit   = 0
    trunks       = null
    vlan_id      = 0
  }

  operating_system {
    type = "l26"
  }
}


# resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
#   name        = "terraform-provider-proxmox-ubuntu-vm"
#   description = "Managed by Terraform"
#   tags        = ["terraform", "ubuntu"]

#   node_name = "pm1"
#   vm_id     = 4321

#   agent {
#     # read 'Qemu guest agent' section, change to true only when ready
#     enabled = false
#   }
#   # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
#   stop_on_destroy = true

#   startup {
#     order      = "3"
#     up_delay   = "60"
#     down_delay = "60"
#   }

#   cpu {
#     cores = 2
#     type  = "x86-64-v2-AES" # recommended for modern CPUs
#   }

#   memory {
#     dedicated = 2048
#     floating  = 2048 # set equal to dedicated to enable ballooning
#   }

#   disk {
#     datastore_id = "local-lvm"
#     import_from  = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
#     interface    = "scsi0"
#   }

#   initialization {
#     ip_config {
#       ipv4 {
#         address = "dhcp"
#       }
#     }

#     user_account {
#       keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
#       password = random_password.ubuntu_vm_password.result
#       username = "ubuntu"
#     }

#     user_data_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
#   }

#   network_device {
#     bridge = "vmbr0"
#   }

#   operating_system {
#     type = "l26"
#   }

#   tpm_state {
#     version = "v2.0"
#   }

#   serial_device {}

#   virtiofs {
#     mapping   = "data_share"
#     cache     = "always"
#     direct_io = true
#   }
# }

resource "proxmox_virtual_environment_download_file" "latest_ubuntu_22_jammy_qcow2_img" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "pm1"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "jammy-server-cloudimg-amd64.qcow2"
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "tls_private_key" "ubuntu_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "ubuntu_vm_password" {
  value     = random_password.ubuntu_vm_password.result
  sensitive = true
}

output "ubuntu_vm_private_key" {
  value     = tls_private_key.ubuntu_vm_key.private_key_pem
  sensitive = true
}

output "ubuntu_vm_public_key" {
  value = tls_private_key.ubuntu_vm_key.public_key_openssh
}
