variable "aws_account_id" {
  type = string
}

variable "aws_region" {
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

variable "project_name" {
  type = string
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

variable "deployment_package" {
  type = string
}


locals {
  function_name_with_prefix = "${var.project_name}-${var.function_name}"
}
