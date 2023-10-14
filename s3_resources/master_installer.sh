#!/bin/bash

cd dns_updater
source ./install.sh
cd ..

cp /opt/tools/service/syslog_valheim.conf /etc/rsyslog.d/42-valheim.conf
cp /opt/tools/service/valheim.service /etc/systemd/system
systemctl daemon-reload
systemctl enable valheim
