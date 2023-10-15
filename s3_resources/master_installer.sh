#!/bin/bash

echo "Now inside master_installer.sh"


#Service
echo "Now installing service and syslog customizations"
cp /opt/tools/service/syslog_valheim.conf /etc/rsyslog.d/42-valheim.conf
cp /opt/tools/service/valheim.service /etc/systemd/system
systemctl daemon-reload
systemctl enable valheim

#DNS
echo "Now installing DNS Updater"
pip install -r /opt/tools/dns_updater/requirements.txt
cp /opt/tools/dns_updater/crontab /etc/cron.d/dnsupdater

#Metrics
echo "Now setting up metric collection"
apt install npm jq -y
npm install gamedig -g
cp /opt/tools/metrics/crontab /etc/cron.d/metrics_collect
# Cloudwatch Agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
cp /opt/tools/metrics/cloudwatch.json /opt/aws/amazon-cloudwatch-agent/bin/config.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

echo "Master installer script finished"
