output "public_ip" {
  description = "Public IP address of the EC2 dev node"
  value       = module.dev_node.first_public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 dev node"
  value       = module.dev_node.first_private_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.dev_node.first_id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.vpc.subnet_id
}

output "allowed_ssh_cidr" {
  description = "CIDR block currently authorized for SSH access"
  value       = local.admin_cidr
}
