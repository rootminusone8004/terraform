output "instance_id" {
  description = "The ID of the Vultr instance"
  value       = vultr_instance.this.id
}

output "public_ip" {
  description = "The primary public IPv4 address of the instance"
  value       = vultr_instance.this.main_ip
}

output "hostname" {
  description = "The hostname of the instance"
  value       = vultr_instance.this.hostname
}

output "username" {
  description = "Configured SSH username"
  value       = var.username
}

output "os_id" {
  description = "Operating System ID"
  value       = vultr_instance.this.os_id
}
