#!/bin/bash
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
INSTANCEID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
valheim_data=$(gamedig --type valheim localhost:2456)
active_players=$(echo $valheim_data| jq .raw.numplayers)
max_players=$(echo $valheim_data| jq .maxplayers)
ping=$(echo $valheim_data|jq .ping)
aws --region $REGION cloudwatch put-metric-data --metric-name active_players --namespace Valheim --unit Count --value $active_players --dimensions InstanceId=$INSTANCEID
aws --region $REGION cloudwatch put-metric-data --metric-name max_players --namespace Valheim --unit Count --value $max_players --dimensions InstanceId=$INSTANCEID
aws --region $REGION cloudwatch put-metric-data --metric-name ping --namespace Valheim --unit Count --value $ping --dimensions InstanceId=$INSTANCEID