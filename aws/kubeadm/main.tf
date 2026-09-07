locals {
  ami_map = {
    debian = data.aws_ami.debian_ami.id
    ubuntu = data.aws_ami.ubuntu_ami.id
    redhat = data.aws_ami.redhat_ami.id
  }
  selected_ami  = lookup(local.ami_map, var.distro, data.aws_ami.debian_ami.id)
  ssh_user      = lookup(var.user_map, var.distro, "admin")
  admin_cidr    = var.allowed_admin_cidr != "" ? var.allowed_admin_cidr : "${chomp(data.http.my_ip.response_body)}/32"
  nodeport_cidr = var.allowed_nodeport_cidr != "" ? var.allowed_nodeport_cidr : local.admin_cidr
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

  name        = "kubeadm_sg"
  description = "Security group for Kubernetes cluster nodes with least privilege ingress"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    # 1. Intra-cluster communication (all cluster nodes communicate freely with each other)
    {
      description = "Allow all internal traffic within the cluster security group"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self        = true
    },
    {
      description = "Allow all internal traffic across VPC subnet"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [var.subnet_ip]
    },
    # 2. Administrative access (SSH and Kubernetes API) restricted to admin IP
    {
      description = "SSH from authorized admin IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [local.admin_cidr]
    },
    {
      description = "Kubernetes API server from authorized admin IP"
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      cidr_blocks = [local.admin_cidr]
    },
    # 3. NodePort services restricted to authorized IP / CIDR
    {
      description = "Kubernetes NodePort services from authorized IP"
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      cidr_blocks = [local.nodeport_cidr]
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

module "control_plane" {
  source = "../../modules/aws/ec2_instance"

  name                   = "control-plane"
  ami                    = local.selected_ami
  instance_type          = var.controller_type
  key_name               = module.key_pair.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = module.vpc.subnet_id
  volume_size            = var.controller_volume_size
  volume_encrypted       = true

  ssh_user                  = local.ssh_user
  ssh_private_key_path      = var.private_key_path
  enable_ssh_config         = true
  enable_env_file           = true
  append_env_file           = false
  include_private_ip_in_env = true

  tags = {
    Name = "control-plane"
    Role = "controller"
  }
}

module "workers" {
  source = "../../modules/aws/ec2_instance"

  instance_count         = var.worker_count
  name                   = "worker"
  ami                    = local.selected_ami
  instance_type          = var.ec2_type
  key_name               = module.key_pair.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = module.vpc.subnet_id
  volume_size            = var.worker_volume_size
  volume_encrypted       = true

  ssh_user                  = local.ssh_user
  ssh_private_key_path      = var.private_key_path
  enable_ssh_config         = true
  enable_env_file           = true
  append_env_file           = true
  include_private_ip_in_env = true

  tags = {
    Role = "worker"
  }
}
