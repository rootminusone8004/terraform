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
  description = "Linux distribution for Kubernetes nodes (debian, ubuntu, redhat)"
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
  }
}

variable "ec2_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t2.medium"
}

variable "controller_type" {
  description = "EC2 instance type for control plane node"
  type        = string
  default     = "t2.medium"
}

variable "worker_count" {
  description = "Number of Kubernetes worker nodes to provision"
  type        = number
  default     = 2
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

variable "controller_volume_size" {
  description = "Root EBS volume size for control plane node in GB"
  type        = number
  default     = 40
}

variable "worker_volume_size" {
  description = "Root EBS volume size for worker nodes in GB"
  type        = number
  default     = 30
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

variable "allowed_admin_cidr" {
  description = "CIDR block allowed for administrative access (SSH and Kubernetes API). If empty, automatically detects current public IP."
  type        = string
  default     = ""
}

variable "allowed_nodeport_cidr" {
  description = "CIDR block allowed to access Kubernetes NodePort services (30000-32767). If empty, defaults to allowed_admin_cidr."
  type        = string
  default     = ""
}
