## AWS Lambda module

This module creates a simple AWS function.
Function can be integrated with AWS Package module to create an on-change triggered function deployment. 

Note: Function will be granted access to the deployment bucket provided in the configuration.

### Provisioned Resources:

 - AWS Lambda
 - IAM Role with CloudWatch & S3 deployment bucket access policy

### Input Variables:

`project_name` - Name of the project (Project name will be included as a prefix in resources)

`function_name` - Lambda function name (Note: final lambda name will consist of project + lambda names)

`policies` - list or IAM policy arns that will be attached to lambda's IAM Role.

`layers` - list of AWS Layer's arns to attached to function.

`enable_cloudwatch_logs` - If true 'AWSLambdaBasicExecutionRole' will be attached. (default: true)

`enable_x_ray_tracing` - If true 'AWSXRayDaemonWriteAccess' will be attached. (default: false)

`deployment_bucket_arn` - ARN of S3 bucket containing the AWS lambda deployment package.

`deployment_bucket_name` - Name of S3 bucket containing the AWS lambda deployment package.

`deployment_package_key` - Key of S3 bucket object with the AWS lambda deployment package.

`tags` - map of lambda tags (Up to 8 can be specified since, Name and Project will be added by default)


### Outputs

`function_name` - Function name

`arn` - ARN of created function

`invoke_arn` - Invoke ARN of created function

`version` - Latest published version of created function


### Example

```terraform
module "lambda" {
  source = "github.com/Mich0232/aws-lambda.git"

  project_name  = "example-project"
  function_name = "my-service"

  deployment_bucket_arn  = aws_s3_bucket.deployment_bucket.arn
  deployment_bucket_name = aws_s3_bucket.deployment_bucket.bucket
  deployment_package_key = "my-service/build.zip"
  source_code_hash       = "83bc6426i7b73ci"
}
```

Using [aws-package module](https://github.com/Mich0232/aws-package):


```terraform
module "code" {
  source = "github.com/Mich0232/aws-package.git"

  deployment_bucket_id     = aws_s3_bucket.deployment_bucket.id
  deployment_bucket_prefix = "example"
  source_dir               = "../src"
  output_dir               = "../output/code"

  hash_sources   = [ "*.py" ]
  excluded_paths = [ "__pycache__" ]
}


module "lambda" {
  source = "github.com/Mich0232/aws-lambda.git"

  project_name  = "example-project"
  function_name = "my-service"

  deployment_bucket_arn  = aws_s3_bucket.deployment_bucket.arn
  deployment_bucket_name = aws_s3_bucket.deployment_bucket.bucket
  deployment_package_key = module.code.key
  source_code_hash       = module.code.output_base64sha256
}
```
