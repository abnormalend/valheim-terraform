resource "aws_security_group" "valheim_security" {
  name        = "valheim_security"
  description = "Allow access for game server port, steam,  and ec2 anywhere"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.valheim_security.id
  description       = "Allows unrestricted outbound access"
  cidr_ipv4         = "0.0.0.0/0"
  # from_port         = 0
  # to_port           = 0
  ip_protocol = "-1"
  tags        = { Name = "outbound" }
}

resource "aws_vpc_security_group_ingress_rule" "valheim_game_port" {
  security_group_id = aws_security_group.valheim_security.id
  description       = "Allows whole world access to the valheim server port"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2456
  to_port           = 2456
  ip_protocol       = "udp"
  tags              = { Name = "Valheim Game" }
}

resource "aws_vpc_security_group_ingress_rule" "steam_query_port" {
  security_group_id = aws_security_group.valheim_security.id
  description       = "Allows whole world access to the steam query port"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2457
  to_port           = 2457
  ip_protocol       = "udp"
  tags              = { Name = "Steam Query" }
}

resource "aws_vpc_security_group_ingress_rule" "instance_connect_port" {
  security_group_id = aws_security_group.valheim_security.id
  description       = "Allows shell access through EC2 instance connect"
  cidr_ipv4         = "3.16.146.0/29"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  tags              = { Name = "EC2 Instance Connect" }
}