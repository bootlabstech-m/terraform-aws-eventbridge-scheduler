# Get Existing Lambda Function
data "aws_lambda_function" "existing" {
  function_name = var.lambda_function_name
}

# EventBridge Scheduler
resource "aws_scheduler_schedule" "lambda_schedule" {
  name                         = var.scheduler_name
  description                  = var.scheduler_description
  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = "Asia/Kolkata"
  state                        = "ENABLED"

  flexible_time_window {
    mode = "FLEXIBLE"
    maximum_window_in_minutes = var.maximum_window_in_minutes
    
  }

  target {
    arn      = data.aws_lambda_function.existing.arn
    role_arn = aws_iam_role.scheduler_role.arn
    retry_policy {
      maximum_event_age_in_seconds = var.retry_policy_event_age_seconds
      maximum_retry_attempts = var.retry_policy_max_retry_attempts
    }
  }
}

# IAM Role for EventBridge Scheduler
resource "aws_iam_role" "scheduler_role" {
  name = "eventbridge-scheduler-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy Attachment
resource "aws_iam_role_policy" "scheduler_policy" {
  name = "eventbridge-scheduler-lambda-policy"
  role = aws_iam_role.scheduler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = data.aws_lambda_function.existing.arn
      }
    ]
  })
}

# Allow Scheduler to Invoke Lambda
resource "aws_lambda_permission" "allow_scheduler" {
  statement_id  = "AllowExecutionFromScheduler"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.existing.function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.lambda_schedule.arn
}