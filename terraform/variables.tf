variable "pve_endpoint" {
  type = string
}

variable "pve_node" {
  type        = string
  description = "Nome do nó no Proxmox (aparece na árvore da interface web)"
}

variable "datastore" {
  type    = string
  default = "local-lvm"
}

variable "gateway" {
  type = string
}

variable "ssh_pubkey_paths" {
  type    = list(string)
}
