resource "vultr_ssh_key" "default" {
  name    = "terraform-debian-key"
  ssh_key = file(var.ssh_public_key)
}

resource "vultr_instance" "debian" {
  plan   = var.plan
  region = var.region
  os_id  = var.os_id

  hostname = var.hostname

  ssh_key_ids = [
    vultr_ssh_key.default.id
  ]

  tags = [
    "terraform",
    "debian"
  ]

  provisioner "file" {
    content = templatefile("bootstrap.sh.tpl", {
      username       = var.username
      ssh_public_key = file(var.ssh_public_key)
    })

    destination = "/tmp/bootstrap.sh"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key)
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
      private_key = file(var.ssh_private_key)
      host        = self.main_ip
    }
  }

  provisioner "local-exec" {
    command = templatefile("linux-ssh-config.tpl", {
      alias        = "debian-vultr"
      hostname     = self.main_ip
      user         = var.username
      identityFile = var.ssh_private_key
    })

    interpreter = ["bash", "-c"]
  }
}
