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

# This option gets rid of the new interactive prompt mode for restarts happening
echo "\$nrconf{restart} = 'a';" >> /etc/needrestart/needrestart.conf

# Set up a bunch of new repos
deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free
deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free

# Install some pre-requisites
apt install software-properties-common -y
dpkg --add-architecture i386
apt update

# Set up these prompt responses so steamcmd can be nonintereactive
echo steam steam/question select "I AGREE" | sudo debconf-set-selections
echo steam steam/license note '' | sudo debconf-set-selections

# Install steamcmd
apt install lib32gcc-s1 steamcmd -y

# Set up our values
export valheim_dir="/opt/valheim"

mkdir -p $valheim_dir
/usr/games/steamcmd +@sSteamCmdForcePlatformType linux \
                    +force_install_dir $valheim_dir \
                    +login anonymous \
                    +app_update 896660 \
                    -beta none validate \
                    +quit

apt upgrade -y
reboot
EOF

  user_data_replace_on_change = true
}