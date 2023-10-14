#!/usr/bin/python3
import boto3
import requests

instance = requests.get("http://169.254.169.254/latest/meta-data/instance-id").text
region = requests.get("http://169.254.169.254/latest/meta-data/placement/region").text
ec2 = boto3.resource('ec2', region_name=region)
myinstance = ec2.Instance(instance)

# Look up the Hostname tag
try:
    myMachine = next(t["Value"] for t in myinstance.tags if t["Key"] == "dns_hostname")
except StopIteration:
    print("Unable to locate tag 'dns_hostname', cannot continue")
    exit(1)
    
# Look up the Hosted Zone tag
try:
    myZone = next(t["Value"] for t in myinstance.tags if t["Key"] == "dns_zone")
except StopIteration:
    print("Unable to locate tag 'dns_zone', cannot continue")
    exit(1)

myCurrIP = requests.get("http://169.254.169.254/latest/meta-data/public-ipv4").text

# Make a connection to Route53 to update the record
conn53 = boto3.client('route53')
myzone = conn53.list_hosted_zones()

try:
    myzoneid = next(z["Id"] for z in myzone['HostedZones'] if z["Name"] == myZone)
except StopIteration:
    print("Unable to find hosted zone in route53, unable to update DNS")
    exit(1)

response = conn53.change_resource_record_sets(
    HostedZoneId=myzoneid,
    ChangeBatch={
        "Comment": "Automatic DNS update",
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": myMachine + "." + myZone,
                    "Type": "A",
                    "TTL": 180,
                    "ResourceRecords": [
                        {
                            "Value": myCurrIP
                        },
                    ],
                }
            },
        ]
    }
)

print("DNSLOG: " + myMachine + "." + myZone + " updated to " + myCurrIP)