# Server stuff will go here

resource "aws_instance" "valheim" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = "ValheimServer"
  }
  security_groups = [aws_security_group.valheim_security.id]
}