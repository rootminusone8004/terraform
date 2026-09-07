module "linux_server" {
  source = "../../modules/vultr/instance"

  hostname                = var.hostname
  region                  = var.region
  plan                    = var.plan
  os_id                   = var.os_id
  ssh_key_name            = "terraform-debian-key"
  ssh_public_key_path     = var.ssh_public_key
  ssh_private_key_path    = var.ssh_private_key
  username                = var.username
  tags                    = ["terraform", "debian"]
  bootstrap_template_path = "${path.module}/scripts/bootstrap.sh.tpl"
  ssh_config_alias        = "debian-vultr"
  forward_x11             = true
}
