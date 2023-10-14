#!/bin/sh
export valheim_dir="/opt/valheim"
export s3_bucket="${bucket_name}"
export user="valheim"
export user_group="$user:$user"

groupadd $user
useradd --system --shell /bin/nologin --home $valheim_dir -g $user $user
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

# Install steamcmd and friends
apt install lib32gcc-s1 steamcmd awscli python3-pip -y

mkdir -p /opt/tools
aws s3 sync s3://$s3_bucket/resources/ /opt/tools
chown $user_group -R /opt/tools

source /opt/tools/master_installer.sh

/usr/games/steamcmd +@sSteamCmdForcePlatformType linux \
                    +force_install_dir $valheim_dir \
                    +login anonymous \
                    +app_update 896660 \
                    -beta none validate \
                    +quit

chown $user_group -R $valheim_dir

# make sure everything is up to date
apt upgrade -y

# Must be the end, nothing else will happen after this
reboot
