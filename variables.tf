variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "tags" {
  description = "Tags to put on everything"
  type        = map(string)
  default = {
    project = "valheim-terraform"
  }
}

variable "instance_type" {
  description = "What type of instance to deploy"
  type = string
  default = "t3.large"
}