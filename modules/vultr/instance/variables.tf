variable "hostname" {
  description = "Hostname for the Vultr instance"
  type        = string
}

variable "region" {
  description = "Vultr region identifier (e.g. ams, ewr)"
  type        = string
  default     = "ams"
}

variable "plan" {
  description = "Vultr instance plan (e.g. vc2-1c-1gb)"
  type        = string
  default     = "vc2-1c-1gb"
}

variable "os_id" {
  description = "Vultr operating system ID"
  type        = number
}

variable "ssh_key_name" {
  description = "Name of the SSH key to register in Vultr"
  type        = string
  default     = "terraform-key"
}

variable "ssh_public_key_path" {
  description = "Path to local SSH public key"
  type        = string
  default     = "~/.ssh/ansible.pub"
}

variable "ssh_private_key_path" {
  description = "Path to local SSH private key used for provisioning"
  type        = string
  default     = "~/.ssh/ansible"
}

variable "username" {
  description = "Non-root SSH username to configure on the server"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags to assign to the Vultr instance"
  type        = list(string)
  default     = ["terraform"]
}

variable "bootstrap_template_path" {
  description = "Path to the bootstrap template script"
  type        = string
}

variable "bootstrap_extra_vars" {
  description = "Additional template variables for the bootstrap script"
  type        = map(any)
  default     = {}
}

variable "ssh_config_alias" {
  description = "Alias to use for the host in ~/.ssh/config (defaults to main_ip if empty)"
  type        = string
  default     = ""
}

variable "forward_x11" {
  description = "Whether to enable X11 forwarding in SSH config"
  type        = bool
  default     = true
}

variable "enable_ssh_config" {
  description = "Whether to append entry to ~/.ssh/config"
  type        = bool
  default     = true
}

variable "enable_env_file" {
  description = "Whether to generate local env file"
  type        = bool
  default     = true
}
