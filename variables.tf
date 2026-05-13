# variables.tf

variable "region" {
  type        = string
  description = "AWS region where the EventBridge Scheduler and Lambda resources will be managed."
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the existing AWS Lambda function to be triggered by the EventBridge Scheduler."
}

variable "scheduler_name" {
  type        = string
  description = "Unique name for the EventBridge Scheduler responsible for invoking the Lambda function."
}

variable "scheduler_description" {
  type        = string
  description = "Description for the EventBridge Scheduler used to identify the purpose of the scheduled Lambda invocation."
}

variable "schedule_expression" {
  type        = string
  description = "Cron or rate expression that defines when the Lambda function should be triggered."
}

variable "maximum_window_in_minutes" {
  type        = number
  default     = 5
  description = "Maximum flexible time window in minutes during which EventBridge Scheduler can delay the Lambda invocation."
}

variable "retry_policy_event_age_seconds" {
  type        = number
  description = "Maximum age of the event in seconds that EventBridge Scheduler should retry delivering to the target before discarding the event."
  default     = 3600
}

variable "retry_policy_max_retry_attempts" {
  type        = number
  description = "Maximum number of retry attempts EventBridge Scheduler should make when invoking the target fails."
  default     = 3
}

variable "role_arn" {
  description = " The ARN of the IAM role"
  type = string
}