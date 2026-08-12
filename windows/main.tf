resource "aws_vpc" "mtc_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.subnet_ip
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

resource "aws_security_group" "mtc_sg" {
  name        = "dev_windows_sg"
  description = "Windows Server security group"
  vpc_id      = aws_vpc.mtc_vpc.id

  # Windows Remote Desktop
  # Only allow the public IP detected during terraform apply.
  ingress {
    description = "RDP from current public IP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Windows outbound Internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-windows-sg"
  }
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtckey"
  public_key = file("~/.ssh/windows_aws.pub")
}

resource "aws_instance" "dev_node" {
  ami           = data.aws_ssm_parameter.windows_server_2022.value
  instance_type = var.ec2_type

  key_name               = aws_key_pair.mtc_auth.key_name
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id

  get_password_data = true

  user_data = <<-EOF
    <powershell>
    $password = ConvertTo-SecureString "${var.admin_password}" -AsPlainText -Force
    Set-LocalUser -Name "Administrator" -Password $password
    </powershell>
  EOF

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "dev-windows-server"
    OS   = "Windows Server 2022"
  }
  provisioner "local-exec" {
    command = templatefile("linux-ssh-config.tpl", {
      hostname     = self.public_ip
      user         = "Administrator"
      identityFile = "~/.ssh/windows_aws"
    })
    interpreter = ["bash", "-c"]
  }
}

output "public_ip" {
  description = "Windows Server public IP"
  value       = aws_instance.dev_node.public_ip
}

output "private_ip" {
  description = "Windows Server private IP"
  value       = aws_instance.dev_node.private_ip
}

output "rdp_allowed_ip" {
  description = "Public IP currently allowed to RDP"
  value       = "${chomp(data.http.my_ip.response_body)}/32"
}

output "instance_id" {
  description = "Windows EC2 instance ID"
  value       = aws_instance.dev_node.id
}

output "rdp_command" {
  description = "Windows RDP command"
  value       = "mstsc /v:${aws_instance.dev_node.public_ip}"
}
