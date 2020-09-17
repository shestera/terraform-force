output "mongodb_password" {
  value       = random_string.mongo-password.result
  description = "The password for logging in to the database."
  sensitive   = true
}