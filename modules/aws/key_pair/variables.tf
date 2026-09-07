variable "key_name" {
  description = "The name for the key pair"
  type        = string
}

variable "public_key" {
  description = "The public key material (optional if public_key_path is provided)"
  type        = string
  default     = ""
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/ansible.pub"
}

variable "tags" {
  description = "Tags to attach to the key pair"
  type        = map(string)
  default     = {}
}
