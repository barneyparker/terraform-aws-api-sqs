data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "sqs_integration" {
  source = "github.com/barneyparker/terraform-aws-api-generic"

  name               = var.name
  api_id             = var.api_id
  resource_id        = var.resource_id
  http_method        = var.http_method
  authorization      = var.authorization
  method_request_parameters = var.method_request_parameters

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:sqs:path/${data.aws_caller_identity.current.account_id}/${var.queue_name}"
  credentials             = aws_iam_role.sqs_publish.arn

  integration_request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates       = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }

  responses = var.responses

}

resource "aws_iam_role" "sqs_publish" {
  name = "${var.name}-sqs-publish"
  assume_role_policy = data.aws_iam_policy_document.apigw.json
}

data "aws_iam_policy_document" "apigw" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "sqs_publish" {
  name = "SQS-Publish"
  role = aws_iam_role.sqs_publish.id
  policy = data.aws_iam_policy_document.sqs_publish.json
}

data "aws_iam_policy_document" "sqs_publish" {
  statement {
     actions = [
      "sqs:SendMessage",
    ]

    resources = [
      "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.queue_name}",
    ]
  }
}