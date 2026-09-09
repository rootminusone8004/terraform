variable "region" {
  description = "Vultr region"
  type        = string
  default     = "ams"
}

variable "plan" {
  description = "Vultr instance plan"
  type        = string
  default     = "vc2-1c-1gb"
}

variable "hostname" {
  description = "VPS hostname"
  type        = string
  default     = "debian-server"
}

variable "username" {
  description = "Non-root SSH username"
  type        = string
  default     = "dev"
}

variable "os_id" {
  description = "Vultr Debian OS ID"
  type        = number
  default     = 2625
}

variable "ssh_public_key" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/ansible.pub"
}

variable "ssh_private_key" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/ansible"
}
