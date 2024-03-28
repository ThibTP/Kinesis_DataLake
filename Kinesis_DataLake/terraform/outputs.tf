output "stream_arn" {
  description = "ARN of the Kinesis stream"
  value       = aws_kinesis_stream.event_stream.arn
}

output "bucket_name" {
  description = "S3 bucket Name"
  value       = aws_s3_bucket.event_bucket.bucket
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.event_processor.arn
}

output "glue_catalog_arn" {
  description = "ARN of the Glue Data Catalog"
  value       = aws_glue_catalog_database.my_database.arn
}
