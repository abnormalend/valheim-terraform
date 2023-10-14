resource "aws_iam_instance_profile" "valheim_profile" {
  name = "valheim_profile"
  role = aws_iam_role.valheim_role.name
}

resource "aws_iam_role" "valheim_role" {
  name               = "valheim_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "s3_access" {
    statement {
      effect = "Allow"
      actions = ["s3:*"]
      resources = [aws_s3_bucket.bucket.arn, "${aws_s3_bucket.bucket.arn}/*"]
    }
}

resource "aws_iam_role_policy" "s3_access" {
  name = "s3_access"
  role = aws_iam_role.valheim_role.name
  policy = data.aws_iam_policy_document.s3_access.json
}

data "aws_route53_zone" "rgrs_zone" {
    name = var.hosted_zone
  
}

data "aws_iam_policy_document" "r53_access" {
    statement {
        effect = "Allow"
        actions = ["route53:ChangeResourceRecordSets"]
        resources = [data.aws_route53_zone.rgrs_zone.arn]
    }
}

resource "aws_iam_role_policy" "r53_access" {
  name = "r53_access"
  role = aws_iam_role.valheim_role.name
  policy = data.aws_iam_policy_document.r53_access.json
}

data "aws_iam_policy_document" "self_access" {
    statement {
        effect = "Allow"
        actions = ["ec2:*"]
        resources = [aws_instance.valheim.arn]
    }
}

resource "aws_iam_role_policy" "self_access" {
    name = "self_access"
    role = aws_iam_role.valheim_role.name
    policy = data.aws_iam_policy_document.self_access.json
}