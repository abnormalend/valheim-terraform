data "aws_vpc" "default" {
  default = true
}

data "aws_caller_identity" "current" {} # data.aws_caller_identity.current.account_id
data "aws_region" "current" {}          # data.aws_region.current.name

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_iam_policy" "cloudwatch_policy" {
  name = "CloudWatchAgentServerPolicy"
}