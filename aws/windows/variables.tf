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

variable "ec2_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
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
  default     = 50
}

variable "admin_password" {
  description = "Administrator password for the Windows Server"
  type        = string
  sensitive   = true
}

variable "allowed_admin_cidr" {
  description = "CIDR block allowed for administrative access (RDP and WinRM). If empty, automatically detects current public IP."
  type        = string
  default     = ""
}

variable "allowed_rdp_cidr" {
  description = "Deprecated: Use allowed_admin_cidr instead. CIDR block allowed to connect via RDP."
  type        = string
  default     = ""
}

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/windows_aws.pub"
}

variable "private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/windows_aws"
}
