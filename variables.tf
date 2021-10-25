variable "lambda_role_name" {
  description = "Name for IAM role required for nlb-alb-connector-lambda"
  type        = string
  default     = "nlb-alb-connector-lambda-role"
}

variable "lambda_policy_name" {
  description = "Name for IAM role required for nlb-alb-connector-lambda"
  type        = string
  default     = "nlb-alb-connector-lambda-policy"
}

variable "lambda_function_name" {
  description = "Name for nlb-alb-connector-lambda"
  type        = string
  default     = "nlb-alb-connector-lambda"
}

variable "alb_dns_name" {
  description = "DNS of ALB"
  type        = string
}

variable "alb_listener" {
  description = "Port of ALB"
  type        = number
}

variable "nlb_target_arn" {
  description = "Target ARN of NLB"
  type        = string
}

variable "bucket_name" {
  description = "Name of required S3 bucket used by Lambda"
  type        = string
}

variable "bucket_destroy" {
  description = "Force destroy of S3 bucket used by Lambda"
  type        = string
  default     = "false"
}

variable "cloudwatch_event_rule_name" {
  description = "Name of Cloudwatch event rule"
  type        = string
  default     = ""
}
