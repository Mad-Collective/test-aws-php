data "aws_iam_policy_document" "agent-lambda-assume-role-policy" {
  statement {
    sid    = "LambdaAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "agent-lambda-role" {
  name                 = "${var.environment}-${local.component}-agent-lambda-role"
  assume_role_policy   = data.aws_iam_policy_document.agent-lambda-assume-role-policy.json
}

data "aws_iam_policy_document" "agent-lambda-resources-policy" {
  statement {
    sid    = "sqs"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      aws_sqs_queue.agent-lambda-dlq.arn,
      aws_sqs_queue.queue.arn,
    ]
  }
}

data "archive_file" "lambda-zip" {
  type                    = "zip"
  source_dir              = "../../../../src/lambdas/${local.component}-agent"
  output_path             = "/tmp/dist/${var.environment}-${local.component}-agent-lambda.zip"
}

resource "aws_lambda_function" "agent-lambda" {
  function_name = "${var.environment}-${local.component}-agent"
  filename      = data.archive_file.lambda-zip.output_path
  role          = aws_iam_role.agent-lambda-role.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  timeout       = 10

  environment {
    variables = {
      TRAFFIC_QUEUE_URL = aws_sqs_queue.queue.id
    }
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.agent-lambda-dlq.arn
  }
}

resource "aws_sqs_queue" "agent-lambda-dlq" {
  name = "${var.environment}-${local.component}-agent-lambda-dlq"
}
