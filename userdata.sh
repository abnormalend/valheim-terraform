#!/bin/sh
export valheim_dir="/opt/valheim"
groupadd valheim
useradd --system --shell /bin/nologin --home $valheim_dir -g valheim valheim
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
chown valheim:valheim /opt/tools

# mkdir -p $valheim_dir
/usr/games/steamcmd +@sSteamCmdForcePlatformType linux \
                    +force_install_dir $valheim_dir \
                    +login anonymous \
                    +app_update 896660 \
                    -beta none validate \
                    +quit

# make sure everything is up to date
apt upgrade -y

# Must be the end, nothing else will happen after this
reboot
