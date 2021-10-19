provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Owner = "rex.chun"
    }
  }
}

variable "eventbridge_rule_name" {
  type    = string
  default = "ec2-sg"
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus  = false
  create_role = false

  rules = {
    "${var.eventbridge_rule_name}" = {
      description   = "Capture security group data"
      event_pattern = <<PATTERN
        {
            "source": ["aws.ec2"],
            "detail-type": ["AWS API Call via CloudTrail"],
            "detail": {
                "eventSource": ["ec2.amazonaws.com"],
                "eventName": [
                    {
                        "prefix": "AuthorizeSecurityGroup"
                    },
                    {
                        "prefix": "RevokeSecurityGroup"
                    },
                    {
                        "prefix": "ModifySecurityGroupRules"
                    }
                ]
            }
        }
        PATTERN
    }
  }

  targets = {
    "${var.eventbridge_rule_name}" = [
      {
        name = "ec2-sg-lambda-target"
        arn  = module.lambda_function.lambda_function_arn
      }
    ]
  }
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda1"
  description   = "My awesome lambda function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  source_path = "./lambda-function1"

  allowed_triggers = {
    EventBridge = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_rule_arns[var.eventbridge_rule_name]
    }
  }
  create_current_version_allowed_triggers = false
}
