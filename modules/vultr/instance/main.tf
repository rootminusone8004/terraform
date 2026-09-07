resource "vultr_ssh_key" "this" {
  name    = var.ssh_key_name
  ssh_key = file(pathexpand(var.ssh_public_key_path))
}

resource "vultr_instance" "this" {
  plan     = var.plan
  region   = var.region
  os_id    = var.os_id
  hostname = var.hostname

  ssh_key_ids = [
    vultr_ssh_key.this.id
  ]

  tags = var.tags

  provisioner "file" {
    content = templatefile(pathexpand(var.bootstrap_template_path), merge(
      {
        username       = var.username
        ssh_public_key = file(pathexpand(var.ssh_public_key_path))
      },
      var.bootstrap_extra_vars
    ))

    destination = "/tmp/bootstrap.sh"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(pathexpand(var.ssh_private_key_path))
      host        = self.main_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 700 /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(pathexpand(var.ssh_private_key_path))
      host        = self.main_ip
    }
  }

  provisioner "local-exec" {
    command     = <<-EOT
      %{if var.enable_ssh_config}
      mkdir -p ~/.ssh && chmod 700 ~/.ssh
      {
        printf 'Host %s\n' '${var.ssh_config_alias != "" ? var.ssh_config_alias : self.main_ip}'
        printf '  Hostname %s\n' '${self.main_ip}'
        printf '  User %s\n' '${var.username}'
        %{if var.forward_x11}
        printf '  ForwardX11 yes\n'
        printf '  ForwardX11Trusted yes\n'
        %{endif}
        printf '  IdentityFile %s\n\n' '${var.ssh_private_key_path}'
      } >> ~/.ssh/config
      %{endif}
      %{if var.enable_env_file}
      rm -f env && touch env
      if [ -f ~/.vultr/env ]; then
        cat ~/.vultr/env >> env
      fi
      {
        printf 'usr=%s\n' '${var.username}'
        printf 'IP=%s\n' '${self.main_ip}'
      } >> env
      %{endif}
    EOT
    interpreter = ["bash", "-c"]
  }
}
