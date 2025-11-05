terraform {
  required_providers {
    aws    = { source = "hashicorp/aws" }
    random = { source = "hashicorp/random" }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# IAM role for Lambda — unique name to avoid collisions
resource "aws_iam_role" "lambda_role_1" {
  name = "lambda_execution_role_${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role_1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# unique bucket name using the same random suffix
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "zxfghuiotrdfbnmlo987tfvbn-${random_id.suffix.hex}"
  tags = {
    Name = "lambda-bucket"
  }
}

# Upload python.zip (ensure python.zip exists locally)
resource "aws_s3_object" "lambda" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "python.zip"
  source = "python.zip"
  etag   = filemd5("python.zip")
}

# Lambda function uses unique function_name to avoid collisions with existing functions
resource "aws_lambda_function" "my_lambda" {
  function_name = "lambda_s3_${random_id.suffix.hex}"
  role          = aws_iam_role.lambda_role_1.arn
  handler       = "python.lambda_handler"  # ensure your zip contains python.py with lambda_handler
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128

  s3_bucket         = aws_s3_bucket.lambda_bucket.bucket
  s3_key            = aws_s3_object.lambda.key
  s3_object_version = aws_s3_object.lambda.version_id

  depends_on = [aws_s3_object.lambda, aws_iam_role_policy_attachment.lambda_policy]
}

# CloudWatch Log Group for the Lambda with retention
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.my_lambda.function_name}"
  retention_in_days = 14
  tags = {
    Name = "${aws_lambda_function.my_lambda.function_name}-logs"
  }

  depends_on = [aws_lambda_function.my_lambda]
}

# EventBridge scheduled trigger (every 5 minutes)
resource "aws_cloudwatch_event_rule" "every_5_minutes" {
  name                = "invoke-lambda-every-5-minutes-${random_id.suffix.hex}"
  description         = "Trigger the lambda_s3 function every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.every_5_minutes.name
  arn  = aws_lambda_function.my_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_5_minutes.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.my_lambda.function_name
}

output "event_rule_arn" {
  value = aws_cloudwatch_event_rule.every_5_minutes.arn
}
