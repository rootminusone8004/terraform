variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "name" {
  description = "Base name for the instance(s)"
  type        = string
  default     = "instance"
}

variable "ami" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name to associate with the instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
}

variable "subnet_id" {
  description = "VPC Subnet ID to launch the instance in"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = true
}

variable "volume_size" {
  description = "Size of the root block device in GB"
  type        = number
  default     = 10
}

variable "volume_type" {
  description = "Type of the root volume (e.g. gp2, gp3)"
  type        = string
  default     = "gp2"
}

variable "volume_encrypted" {
  description = "Whether to encrypt the root block device"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script to run on instance start"
  type        = string
  default     = null
}

variable "get_password_data" {
  description = "Whether to get password data (for Windows instances)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to attach to the instance"
  type        = map(string)
  default     = {}
}

# Local-exec / SSH Provisioner variables
variable "enable_ssh_config" {
  description = "Whether to append SSH host entry to ~/.ssh/config"
  type        = bool
  default     = true
}

variable "enable_env_file" {
  description = "Whether to write or append to local env file"
  type        = bool
  default     = true
}

variable "append_env_file" {
  description = "Whether to append to env file rather than overwriting it"
  type        = bool
  default     = false
}

variable "include_private_ip_in_env" {
  description = "Whether to write prv_IP to env file"
  type        = bool
  default     = false
}

variable "ssh_user" {
  description = "Default SSH user for the instance"
  type        = string
  default     = "admin"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key for local-exec config"
  type        = string
  default     = "~/.ssh/ansible"
}

variable "forward_x11" {
  description = "Whether to enable X11 forwarding in SSH config"
  type        = bool
  default     = false
}

variable "custom_local_exec_command" {
  description = "Custom command to run in local-exec provisioner (overrides default command)"
  type        = string
  default     = null
}
