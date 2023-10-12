resource "aws_cloudwatch_log_group" "valheim_log" {
  name              = "valheim_log"
  retention_in_days = 30
}