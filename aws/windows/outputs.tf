output "public_ip" {
  description = "Windows Server public IP"
  value       = module.windows_node.first_public_ip
}

output "private_ip" {
  description = "Windows Server private IP"
  value       = module.windows_node.first_private_ip
}

output "allowed_cidr" {
  description = "CIDR block authorized for RDP and WinRM access"
  value       = var.allowed_cidr
}

output "instance_id" {
  description = "Windows EC2 instance ID"
  value       = module.windows_node.first_id
}

output "rdp_command" {
  description = "Windows RDP command"
  value       = "mstsc /v:${module.windows_node.first_public_ip}"
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.vpc.subnet_id
}
