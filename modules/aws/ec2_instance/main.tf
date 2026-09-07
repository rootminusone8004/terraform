resource "aws_instance" "this" {
  count = var.instance_count

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address

  get_password_data = var.get_password_data
  user_data         = var.user_data

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = var.volume_encrypted
  }

  tags = merge(
    {
      Name = var.instance_count > 1 ? "${var.name}-${count.index + 1}" : var.name
    },
    var.tags
  )

  provisioner "local-exec" {
    command = (
      var.custom_local_exec_command != null ? var.custom_local_exec_command :
      (!var.enable_ssh_config && !var.enable_env_file) ? "true" :
      <<-EOT
        %{if var.enable_ssh_config}
        mkdir -p ~/.ssh && chmod 700 ~/.ssh
        {
          printf 'Host %s\n' '${self.public_ip}'
          printf '  Hostname %s\n' '${self.public_ip}'
          printf '  User %s\n' '${var.ssh_user}'
          %{if var.forward_x11}
          printf '  ForwardX11 yes\n'
          printf '  ForwardX11Trusted yes\n'
          %{endif}
          printf '  IdentityFile %s\n\n' '${var.ssh_private_key_path}'
        } >> ~/.ssh/config
        %{endif}
        %{if var.enable_env_file}
        %{if !var.append_env_file && count.index == 0}
        rm -f env && touch env
        %{endif}
        {
          printf 'usr=%s\n' '${var.ssh_user}'
          printf 'IP=%s\n' '${self.public_ip}'
          %{if var.include_private_ip_in_env}
          printf 'prv_IP=%s\n' '${self.private_ip}'
          %{endif}
        } >> env
        %{endif}
      EOT
    )
    interpreter = ["bash", "-c"]
  }
}
