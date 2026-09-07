output "key_name" {
  description = "The name of the key pair"
  value       = aws_key_pair.this.key_name
}

output "key_pair_id" {
  description = "The key pair ID"
  value       = aws_key_pair.this.key_pair_id
}

output "arn" {
  description = "The key pair ARN"
  value       = aws_key_pair.this.arn
}
