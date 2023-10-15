resource "aws_cloudwatch_log_group" "valheim_log" {
  name              = "valheim_log"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "shutdown" {
  alarm_name = "shutdown_valheim_when_idle"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = 4
  metric_name = "active_players"
  namespace = "Valheim"
  statistic = "Maximum"
  threshold = 1
  period = 120
  actions_enabled = true
  alarm_actions = []
}