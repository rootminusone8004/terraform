locals {
  user_data = <<-EOF
    <powershell>
    $password = ConvertTo-SecureString "${var.admin_password}" -AsPlainText -Force
    Set-LocalUser -Name "Administrator" -Password $password

    # Allow port 5985 (WinRM HTTP) in Windows Defender Firewall
    New-NetFirewallRule -Name "WinRM-HTTP-5985" -DisplayName "WinRM HTTP (Port 5985)" -Protocol TCP -LocalPort 5985 -Action Allow -Direction Inbound -Profile Any -ErrorAction SilentlyContinue
    netsh advfirewall firewall add rule name="WinRM 5985" dir=in action=allow protocol=TCP localport=5985

    # Configure WinRM HTTP service and authentication for Ansible
    Enable-PSRemoting -Force -SkipNetworkProfileCheck
    winrm quickconfig -q
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'
    Restart-Service -Name WinRM
    </powershell>
  EOF

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

  name        = "dev_windows_sg"
  description = "Windows Server security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "RDP access"
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = [var.allowed_cidr]
    },
    {
      description = "WinRM HTTP"
      from_port   = 5985
      to_port     = 5985
      protocol    = "tcp"
      cidr_blocks = [var.allowed_cidr]
    },
    {
      description = "WinRM HTTPS"
      from_port   = 2201
      to_port     = 2210
      protocol    = "tcp"
      cidr_blocks = [var.allowed_cidr]
    }
  ]

  egress_rules = [
    {
      description = "Allow Windows outbound Internet access"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Name = "dev-windows-sg"
  }
}

module "key_pair" {
  source = "../../modules/aws/key_pair"

  key_name        = "mtckey"
  public_key_path = var.public_key_path
}

module "windows_node" {
  source = "../../modules/aws/ec2_instance"

  name                   = "dev-windows-server"
  ami                    = data.aws_ssm_parameter.windows_server_2025.value
  instance_type          = var.ec2_type
  key_name               = module.key_pair.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = module.vpc.subnet_id
  volume_size            = var.volume_size
  volume_type            = "gp3"
  get_password_data      = true
  user_data              = local.user_data

  ssh_user             = "Administrator"
  ssh_private_key_path = var.private_key_path
  enable_ssh_config    = false
  enable_env_file      = true
  append_env_file      = false

  tags = {
    Name = "dev-windows-server"
    OS   = "Windows Server 2025"
  }
}
