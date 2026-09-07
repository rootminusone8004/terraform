output "instance_id" {
  description = "Vultr instance ID"
  value       = module.bsd_server.instance_id
}

output "public_ip" {
  description = "Public IPv4 address"
  value       = module.bsd_server.public_ip
}

output "username" {
  description = "SSH username"
  value       = module.bsd_server.username
}
