variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.123.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.123.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "map_public_ip_on_launch" {
  description = "Whether to assign public IPs to instances launched in the subnet"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Whether to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "name_prefix" {
  description = "Prefix to use for resource Name tags"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags to attach to all VPC resources"
  type        = map(string)
  default     = {}
}
