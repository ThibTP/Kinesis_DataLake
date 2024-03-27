variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "database_name" {
  description = "Glue database to be created"
  type        = string
  default     = "my_database"
}
