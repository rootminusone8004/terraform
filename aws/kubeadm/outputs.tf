output "public_ip" {
  description = "Public IP addresses of all Kubernetes nodes (control plane first, then workers)"
  value       = concat([module.control_plane.first_public_ip], module.workers.public_ips)
}

output "private_ip" {
  description = "Private IP addresses of all Kubernetes nodes (control plane first, then workers)"
  value       = concat([module.control_plane.first_private_ip], module.workers.private_ips)
}

output "control_plane_public_ip" {
  description = "Public IP address of the control plane node"
  value       = module.control_plane.first_public_ip
}

output "control_plane_private_ip" {
  description = "Private IP address of the control plane node"
  value       = module.control_plane.first_private_ip
}

output "worker_public_ips" {
  description = "Public IP addresses of the worker nodes"
  value       = module.workers.public_ips
}

output "worker_private_ips" {
  description = "Private IP addresses of the worker nodes"
  value       = module.workers.private_ips
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.vpc.subnet_id
}

output "allowed_cidr" {
  description = "CIDR block authorized for inbound traffic"
  value       = var.allowed_cidr
}
