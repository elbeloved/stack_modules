output "endpoint" {
  description = "The connection endpoint in address:port format."
  value       = try(aws_db_instance.stack.endpoint, "")
}

output "id" {
  description = " The RDS instance ID.."
  value       = try(aws_db_instance.stack.id, "")
}

