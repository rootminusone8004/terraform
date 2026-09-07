output "ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.this[*].id
}

output "public_ips" {
  description = "List of public IP addresses"
  value       = aws_instance.this[*].public_ip
}

output "private_ips" {
  description = "List of private IP addresses"
  value       = aws_instance.this[*].private_ip
}

output "first_id" {
  description = "ID of the first instance created"
  value       = length(aws_instance.this) > 0 ? aws_instance.this[0].id : null
}

output "first_public_ip" {
  description = "Public IP of the first instance created"
  value       = length(aws_instance.this) > 0 ? aws_instance.this[0].public_ip : null
}

output "first_private_ip" {
  description = "Private IP of the first instance created"
  value       = length(aws_instance.this) > 0 ? aws_instance.this[0].private_ip : null
}

output "instances" {
  description = "Full instance resource objects"
  value       = aws_instance.this
}
