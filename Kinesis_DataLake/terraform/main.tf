# Defining variables
variable "region" {
  default = "us-east-1"
}

# Defining AWS provider
provider "aws" {
  region = var.region
}

# Defining Kinesis stream
resource "aws_kinesis_stream" "event_stream" {
  name             = "event-stream"
  shard_count      = 1

  # Shard Level Scaling configuration
  shard_level_metrics = ["IncomingBytes"]
  retention_period_hours = 24

  # CloudWatch Alarms for autoscaling
  metric_alarm {
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 1
    metric_name         = "IncomingBytes"
    namespace           = "AWS/Kinesis"
    period              = 300
    statistic           = "Sum"
    threshold           = 1000000
    alarm_description   = "Scale up Kinesis stream if incoming bytes exceed threshold"
    alarm_name          = "ScaleUpKinesisStream"
    alarm_actions       = ["arn:aws:autoscaling:region:account-id:autoScalingGroupName/group"]
  }

  metric_alarm {
    comparison_operator = "LessThanThreshold"
    evaluation_periods  = 1
    metric_name         = "IncomingBytes"
    namespace           = "AWS/Kinesis"
    period              = 300
    statistic           = "Sum"
    threshold           = 500000
    alarm_description   = "Scale down Kinesis stream if incoming bytes fall below threshold"
    alarm_name          = "ScaleDownKinesisStream"
    alarm_actions       = ["arn:aws:autoscaling:region:account-id:autoScalingGroupName/group"]
  }
}

# Defining IAM role for Lambda execution
resource "aws_iam_role" "lambda_role" {
  name = "lambda-exec-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Defining IAM policy for Lambda execution role
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-exec-policy"
  description = "Policy for Lambda execution role"
  policy      = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:DescribeStream",
          "kinesis:ListStreams",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Attaching IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Defining Lambda function
resource "aws_lambda_function" "event_processor" {
  function_name    = "event-processor"
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"

  # Provisioned Concurrency configuration
  provisioned_concurrent_executions = 100
  publish = true

  # Concurrency Scaling configuration
  reserved_concurrent_executions = 100
  concurrency = 100
}

# Defining S3 bucket for storing processed events
resource "aws_s3_bucket" "event_bucket" {
  bucket = "babbel_bucket"
  acl    = "private"
}

# Defining a event source mapping between the Kinesis stream and the Lambda function.
resource "aws_lambda_event_source_mapping" "kinesis_mapping" {
  event_source_arn  = aws_kinesis_stream.event_stream.arn
  function_name     = aws_lambda_function.event_processor.arn
  starting_position = "TRIM_HORIZON"
}

# Defining Glue Data Catalog
resource "aws_glue_catalog_database" "my_database" {
  name = var.database_name
}

# Defining IAM role for Glue crawler
resource "aws_iam_role" "glue_crawler_role" {
  name               = "glue-crawler-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "glue.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Attaching policies to the IAM role
resource "aws_iam_policy_attachment" "glue_crawler_policy_attachment" {
  name       = "glue-crawler-policy-attachment"
  roles      = [aws_iam_role.glue_crawler_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
