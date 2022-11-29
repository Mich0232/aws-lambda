variable "project_name" {
  type = string
}

variable "function_name" {
  type = string
}

variable "timeout" {
  type    = number
  default = 60
}

variable "memory" {
  type    = number
  default = 128
}

variable "runtime" {
  type    = string
  default = "python3.8"
}

variable "handler" {
  type    = string
  default = "main.handler"
}

variable "policies" {
  type        = list(string)
  default     = []
  description = "List of policy ARNs assigned to that lambda"
}

variable "layers" {
  type    = list(string)
  default = []
}

variable "architectures" {
  type    = list(string)
  default = ["x86_64"]
}

variable "source_code_hash" {
  type = string
}

variable "envs" {
  type    = map(string)
  default = {}
}

variable "deployment_bucket_arn" {
  type = string
}

variable "deployment_bucket_name" {
  type = string
}

variable "deployment_package_key" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}

  validation {
    condition     = length(keys(var.tags)) <= 8
    error_message = "You can assign up to 8 tags to the S3 Object."
  }
}

variable "enable_cloudwatch_logs" {
  type    = bool
  default = true
}

variable "enable_x_ray_tracing" {
  type    = bool
  default = false
}

locals {
  function_name_with_prefix     = "${var.project_name}-${var.function_name}"
  cloudwatch_logging_policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  x_ray_policy_arn              = "arn:aws:iam::aws:policy/service-role/AWSXRayDaemonWriteAccess"
}
