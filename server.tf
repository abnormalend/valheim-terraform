# Server stuff will go here

resource "aws_instance" "valheim" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = "ValheimServer"
  }
  vpc_security_group_ids = [ aws_security_group.valheim_security.id ]

  user_data = <<EOF
#!/bin/sh

echo "Hey everybody"

echo "\$nrconf{restart} = 'a';" >> /etc/needrestart/needrestart.conf

deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free

deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free

deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free

apt install software-properties-common
dpkg --add-architecture i386
apt update

echo steam steam/question select "I AGREE" | sudo debconf-set-selections
echo steam steam/license note '' | sudo debconf-set-selections

apt install lib32gcc-s1 steamcmd -y

mkdir -p /opt/valheim
steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir /opt/valheim +login anonymous +app_update 896660 -beta none validate +quit

EOF
  user_data_replace_on_change = true
}