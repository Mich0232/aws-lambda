data "aws_iam_policy_document" "lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${local.function_name_with_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}

data "aws_iam_policy_document" "s3_deployment_bucket_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "${var.deployment_bucket_arn}",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${var.deployment_bucket_arn}/${var.project_name}/*",
    ]
  }
}

resource "aws_iam_policy" "s3_deployment_bucket_access_policy" {
  name   = "${local.function_name_with_prefix}-deployment-bucket-access"
  policy = data.aws_iam_policy_document.s3_deployment_bucket_access.json
}

resource "aws_iam_role_policy_attachment" "deployment_bucket_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_deployment_bucket_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy" {
  for_each   = var.enable_cloudwatch_logs ? [1] : []
  role       = aws_iam_role.lambda_role.name
  policy_arn = local.cloudwatch_logging_policy_arn
}

resource "aws_iam_role_policy_attachment" "x_ray_tracing_policy" {
  for_each   = var.enable_x_ray_tracing ? [1] : []
  role       = aws_iam_role.lambda_role.name
  policy_arn = local.x_ray_policy_arn
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.policies)

  role       = aws_iam_role.lambda_role.name
  policy_arn = each.value
}

