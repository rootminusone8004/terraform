output "instance_id" {
  description = "Vultr instance ID"
  value       = vultr_instance.debian.id
}

output "public_ip" {
  description = "Public IPv4 address"
  value       = vultr_instance.debian.main_ip
}

output "username" {
  description = "SSH username"
  value       = var.username
}
