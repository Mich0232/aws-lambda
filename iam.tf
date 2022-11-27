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

data "aws_iam_policy_document" "lambda_cloudwatch_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:region:${var.aws_account_id}:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/${local.function_name_with_prefix}:*"
    ]
  }
}


resource "aws_iam_policy" "cloudwatch_logs_bucket_access_policy" {
  name   = "${local.function_name_with_prefix}-cloudwatch-logs-access"
  policy = data.aws_iam_policy_document.lambda_cloudwatch_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_bucket_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.policies)

  role       = aws_iam_role.lambda_role.name
  policy_arn = each.value
}

