variable "name" {
  description = "Name of the LXC/container"
  type        = string
}

variable "cores" {
  description = "vCPU count"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 512
}

variable "disk_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 8
}

variable "storage_pool" {
  description = "ProxMox storage pool for root disk (zfs/local)"
  type        = string
  default     = "local-zfs"
}

variable "template" {
  description = "LXC template to use (ProxMox storage:path)"
  type        = string
  default     = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.gz"
}

variable "network_bridge" {
  description = "Bridge to attach the container to"
  type        = string
  default     = "vmbr0"
}

variable "ssh_public_key" {
  description = "SSH public key to inject via cloud-init/userdata"
  type        = string
  default     = ""
}