variable "distro" {
  type    = string
  default = "debian"
}

variable "distro_map" {
  type = map(string)
  default = {
    debian = "data.aws_ami.debian_ami.id"
    ubuntu = "data.aws_ami.ubuntu_ami.id"
  }
}

variable "user_map" {
  type = map(string)
  default = {
    debian = "admin"
    ubuntu = "ubuntu"
  }
}

variable "ec2_type" {
  type    = string
  default = "t2.micro"
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
  default = 10
}
