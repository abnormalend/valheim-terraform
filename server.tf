# Server stuff will go here

resource "aws_instance" "valheim" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.03
      instance_interruption_behavior = "stop"
      spot_instance_type = "persistent"
    }
  }

  tags = {
    Name = "ValheimServer"
    env-s3bucket = aws_s3_bucket.bucket.id
    dns_hostname = "valheim"
    dns_zone = var.hosted_zone
  }

  vpc_security_group_ids = [ aws_security_group.valheim_security.id ]
  iam_instance_profile = aws_iam_instance_profile.valheim_profile.id

  user_data = templatefile("./userdata.sh", {
    bucket_name = aws_s3_bucket.bucket.id
  })
  user_data_replace_on_change = true
}
