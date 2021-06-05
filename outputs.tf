output "role_id" {
  description = "The ID of the role"
  value       = aws_iam_role.lambda_role.id
}

output "role_arn" {
  description = "The ARN of the role"
  value       = aws_iam_role.lambda_role.arn
}

output "policy_id" {
  description = "The ID of the policy"
  value       = aws_iam_policy.lambda_policy.id
}

output "policy_arn" {
  description = "The ARN of the policy"
  value       = aws_iam_policy.lambda_policy.arn
}

output "lambda_id" {
  description = "The ID of the lambda"
  value       = aws_lambda_function.lambda.arn
}

output "lambda_arn" {
  description = "The ARN of the lambda"
  value       = aws_lambda_function.lambda.arn
}

output "bucket_id" {
  description = "The ID of the bucket"
  value       = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.bucket.arn
}