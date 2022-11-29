locals {
  environment_block = length(var.envs) > 0 ? [1] : []
}

resource "aws_lambda_function" "this" {
  function_name = local.function_name_with_prefix
  role          = aws_iam_role.lambda_role.arn

  timeout       = var.timeout
  memory_size   = var.memory
  runtime       = var.runtime
  handler       = var.handler
  architectures = var.architectures

  layers = var.layers

  dynamic "environment" {
    for_each = local.environment_block
    content {
      variables = var.envs
    }
  }

  s3_bucket        = var.deployment_bucket_name
  s3_key           = var.deployment_package
  source_code_hash = var.source_code_hash

  tags = merge(var.tags, {
    Project = var.project_name
    Name    = var.function_name
  })
}
