########################
#### IAM for Lambda ####
########################
data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = var.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
  description        = "role which is required for nlb to alb connector lambda"
}

resource "aws_iam_policy" "lambda_policy" {
  name        = var.lambda_policy_name
  description = "policy which is required for nlb to alb connector lambda"

  // to check of createbucket nodig is?
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "LambdaLogging",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:*"
        ]
      },
      {
        "Sid" : "S3Objects",
        "Action" : [
          "s3:Get*",
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : "${aws_s3_bucket.bucket.arn}/*"
      },
      {
        "Sid" : "S3List",
        "Action" : [
          "s3:ListBucket"
        ],
        "Effect" : "Allow",
        "Resource" : aws_s3_bucket.bucket.arn
      },
      {
        "Sid" : "S3ListAll",
        "Action" : [
          "s3:ListAllMyBuckets"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "ELB",
        "Action" : [
          "elasticloadbalancing:Describe*",
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "ELBTG",
        "Action" : [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ],
        "Effect" : "Allow",
        "Resource" : var.nlb_target_arn
      },
      {
        "Sid" : "CW",
        "Action" : [
          "cloudwatch:putMetricData"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

################
#### Lambda ####
################
resource "aws_lambda_function" "lambda" {
  filename      = "${path.module}/nlb_alb_connector_lambda.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "nlb_alb_connector_lambda.lambda_handler"

  source_code_hash = filebase64sha256("${path.module}/nlb_alb_connector_lambda.zip")
  #source_code_hash = filebase64sha256("./nlb_alb_connector_lambda.zip")

  runtime = "python3.8"
  timeout = 300

  environment {
    variables = {
      ALB_DNS_NAME                      = var.alb_dns_name
      ALB_LISTENER                      = var.alb_listener
      INVOCATIONS_BEFORE_DEREGISTRATION = 3
      MAX_LOOKUP_PER_INVOCATION         = 50
      NLB_TG_ARN                        = var.nlb_target_arn
      S3_BUCKET                         = aws_s3_bucket.bucket.id
      CW_METRIC_FLAG_IP_COUNT           = true
    }
  }
}

###################
#### S3 Bucket ####
###################
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

#############################################
#### CloudWatch Event to trigger Lambda ####
#############################################
resource "aws_cloudwatch_event_rule" "every_minute" {
  name                = "every-minute"
  description         = "Fires every minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}

resource "aws_cloudwatch_event_target" "check_connection_every_minute" {
  rule      = aws_cloudwatch_event_rule.every_minute.name
  target_id = var.lambda_function_name
  arn       = aws_lambda_function.lambda.arn
}