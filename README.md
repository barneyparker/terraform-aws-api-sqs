# terraform-aws-api-sqs

Module to simplify API Gateway SQS service integrations.

## Compatibility

This module is HCL2 compantible only.

## Example

```
provider "aws" {
  region = "eu-west-1"
}

resource "aws_api_gateway_rest_api" "api" {
  name = "api_sqs"
}

resource "aws_sqs_queue" "sqs" {
  name = "sqs_queue"
}

module "api-sns" {
  source = "../"

  name        = "sqs-test"
  api_id      = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id

  http_method = "POST"

  queue_name = aws_sqs_queue.sqs.name

  responses = [
    {
      status_code       = "200"
      selection_pattern = "200"
      templates = {
        "application/json" = jsonencode({
          statusCode = 200
          message    = "OK"
        })
      }
    },
    {
      status_code       = "400"
      selection_pattern = "4\\d{2}"
      templates = {
        "application/json" = jsonencode({
          statusCode = 400
          message    = "Error"
        })
      }
    }
  ]
}
```
