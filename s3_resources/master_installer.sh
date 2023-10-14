#!/bin/bash

echo "Now inside master_installer.sh"

#Service
cp /opt/tools/service/syslog_valheim.conf /etc/rsyslog.d/42-valheim.conf
cp /opt/tools/service/valheim.service /etc/systemd/system
systemctl daemon-reload
systemctl enable valheim

#DNS
pip install -r /opt/tools/dns_updater/requirements.txt
cp /opt/tools/dns_updater/crontab /etc/cron.d/dnsupdater