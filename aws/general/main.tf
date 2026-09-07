locals {
  ami_map = {
    debian = data.aws_ami.debian_ami.id
    ubuntu = data.aws_ami.ubuntu_ami.id
    redhat = data.aws_ami.redhat_ami.id
    kali   = data.aws_ami.kali_ami.id
  }
  selected_ami = lookup(local.ami_map, var.distro, data.aws_ami.kali_ami.id)
  ssh_user     = lookup(var.user_map, var.distro, "admin")
  admin_cidr   = var.allowed_ssh_cidr != "" ? var.allowed_ssh_cidr : "${chomp(data.http.my_ip.response_body)}/32"
}

module "vpc" {
  source = "../../modules/aws/vpc"

  vpc_cidr          = var.cidr_block
  subnet_cidr       = var.subnet_ip
  availability_zone = var.availability_zone
  name_prefix       = "dev"
}

module "security_group" {
  source = "../../modules/aws/security_group"

  name        = "dev_sg"
  description = "Security group for dev node with restricted ingress"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "SSH from authorized admin IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [local.admin_cidr]
    },
    {
      description = "ICMP echo (ping) from authorized admin IP"
      from_port   = 8
      to_port     = 0
      protocol    = "icmp"
      cidr_blocks = [local.admin_cidr]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound internet traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "key_pair" {
  source = "../../modules/aws/key_pair"

  key_name        = "mtckey"
  public_key_path = var.public_key_path
}

module "dev_node" {
  source = "../../modules/aws/ec2_instance"

  name                   = "dev-node"
  ami                    = local.selected_ami
  instance_type          = var.ec2_type
  key_name               = module.key_pair.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = module.vpc.subnet_id
  volume_size            = var.volume_size

  ssh_user             = local.ssh_user
  ssh_private_key_path = var.private_key_path
  forward_x11          = true
  enable_ssh_config    = true
  enable_env_file      = true
  append_env_file      = false

  tags = {
    Name = "dev-node"
    OS   = var.distro
  }
}
