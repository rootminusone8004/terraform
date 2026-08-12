variable "ec2_type" {
  type    = string
  default = "t2.medium"
}

variable "cidr_block" {
  type    = string
  default = "10.123.0.0/16"
}

variable "subnet_ip" {
  type    = string
  default = "10.123.1.0/24"
}

variable "volume_size" {
  type    = number
  default = 50
}

variable "admin_password" {
  type      = string
  sensitive = true
}
