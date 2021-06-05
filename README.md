# Terraform NLB ALB connector
The NLB ALB connector is a Terraform module which makes it easy to create an [AWS Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) (L4) in front of an [AWS Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) (L7). A potential use case could be when a private connection from a different VPC to an ALB in your VPC is needed. AWS PrivateLink uses Network Load Balancers to connect interface endpoints to services. The TCP listener on a NLB accepts the private traffic and forwards it to an internal ALB. The ALB terminates TLS, examines HTTP headers, and routes requests based on your configured rules to target groups with your instances or containers. 

The module will deploy an AWS Lambda function. The lambda will be watching the ALB for IP address changes and will update the NLB target group when needed.

## Usage
```
module "nlb-alb-connector" {
  source = "lvthillo/nlb/alb/connector"
  nlb_target_arn = aws_lb_target_group.nlb-target.arn
  bucket_name = "my-nlb-alb-connector-bucket"
  alb_listener = 443
  alb_dns_name = aws_lb.my-alb.dns_name
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.15 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.15 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_target.check_connection_every_minute](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_iam_policy_document.AWSLambdaTrustPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_dns_name"></a> [alb\_dns\_name](#input\_alb\_dns\_name) | DNS of ALB | `string` | n/a | yes |
| <a name="input_alb_listener_port"></a> [alb\_listener\_port](#input\_alb\_listener\_port) | Port of ALB | `number` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of required S3 bucket used by Lambda | `string` | n/a | yes |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | Name for nlb-alb-connector-lambda | `string` | `"nlb-alb-connector-lambda"` | no |
| <a name="input_lambda_policy_name"></a> [lambda\_policy\_name](#input\_lambda\_policy\_name) | Name for IAM role required for nlb-alb-connector-lambda | `string` | `"nlb-alb-connector-lambda-policy"` | no |
| <a name="input_lambda_role_name"></a> [lambda\_role\_name](#input\_lambda\_role\_name) | Name for IAM role required for nlb-alb-connector-lambda | `string` | `"nlb-alb-connector-lambda-role"` | no |
| <a name="input_nlb_target_arn"></a> [nlb\_target\_arn](#input\_nlb\_target\_arn) | Target ARN of NLB | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID of the bucket |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | The ARN of the lambda |
| <a name="output_lambda_id"></a> [lambda\_id](#output\_lambda\_id) | The ID of the lambda |
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | The ARN of the policy |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | The ID of the policy |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The ID of the role |
