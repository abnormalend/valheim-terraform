# Server stuff will go here

resource "aws_instance" "valheim" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

#   instance_market_options {
#     spot_options {
#       max_price = 0.0031
#     }
#   }

  tags = {
    Name = "ValheimServer"
    env-s3bucket = aws_s3_bucket.bucket.id
    dns_hostname = "valheim"
    dns_zone = var.hosted_zone
  }

  vpc_security_group_ids = [ aws_security_group.valheim_security.id ]
  iam_instance_profile = aws_iam_instance_profile.valheim_profile.id

  user_data = file("./userdata.sh")
  user_data_replace_on_change = true
}
