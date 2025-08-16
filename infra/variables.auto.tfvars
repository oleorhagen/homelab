### variables.auto.tfvars
ct_bridge                      = "vmbr0"
ct_datastore_storage_location  = "local"
ct_datastore_template_location = "local"
ct_disk_size                   = "20"
ct_nic_rate_limit              = 10
ct_memory                      = 128
ct_source_file_path            = "http://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
dns_domain                     = "domain.net"
dns_server                     = "192.168.1.1"
gateway                        = "192.168.1.1"
os_type                        = "debian"
pve_api_token                  = "root@pam!terraform=<password>"
pve_api_user                   = "terrabot"
pve_host_address               = "https://100.115.148.42:8006"
tmp_dir                        = "/var/tmp"
