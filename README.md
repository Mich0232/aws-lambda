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
