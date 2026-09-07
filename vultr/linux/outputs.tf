output "instance_id" {
  description = "Vultr instance ID"
  value       = module.linux_server.instance_id
}

output "public_ip" {
  description = "Public IPv4 address"
  value       = module.linux_server.public_ip
}

output "username" {
  description = "SSH username"
  value       = module.linux_server.username
}
