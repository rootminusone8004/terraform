variable "region" {
  description = "AWS region for provisioning resources"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "AWS availability zone for subnet"
  type        = string
  default     = "us-east-1a"
}

variable "distro" {
  description = "Linux distribution to launch (debian, ubuntu, redhat, kali)"
  type        = string
  default     = "debian"
}

variable "user_map" {
  description = "Mapping of Linux distribution to default SSH username"
  type        = map(string)
  default = {
    debian = "admin"
    ubuntu = "ubuntu"
    redhat = "ec2-user"
    kali   = "kali"
  }
}

variable "ec2_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.123.0.0/16"
}

variable "subnet_ip" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.123.1.0/24"
}

variable "volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 10
}

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/ansible.pub"
}

variable "private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/ansible"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to connect via SSH. If empty, automatically detects current public IP."
  type        = string
  default     = ""
}
