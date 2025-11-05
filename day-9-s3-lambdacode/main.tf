terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
    random = { source = "hashicorp/random" }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role_${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "zxdfghyuioiuytrewrfghjk-${random_id.suffix.hex}"
  force_destroy = true
  tags = { Name = "lambda-bucket" }
}

resource "aws_s3_object" "lambda" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "python.zip"
  source = "python.zip"            # must exist locally
  etag   = filemd5("python.zip")
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "lambda_s3_${random_id.suffix.hex}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"  # file: lambda_function.py, function: lambda_handler
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128

  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  s3_key    = aws_s3_object.lambda.key

  depends_on = [aws_iam_role_policy_attachment.lambda_policy, aws_s3_object.lambda]
}
