# DNS Updater
This script will read a target hostname/zone from ec2 tags, and update that record with the public IP address of the instance.

## Requirements
- boto3
- requests
- permissions to read instance tags, and permission to update dns record in the zone

## Role permissions
The following CDK will grant the instance permission to update the record in the hosted zone.  This also requires some of the permissions described in the readme for paper_updater.

    dns_zone = dns.HostedZone.from_lookup(self, "DNS Zone", domain_name = *<your hosted zone goes here>* )

    role.attach_inline_policy(iam.Policy(self, "DNS Updating Access", statements = [iam.PolicyStatement(effect=iam.Effect.ALLOW,
                                            resources=[minecraft_server_arn],
                                            actions=["ec2:*"]),
                                            iam.PolicyStatement(effect=iam.Effect.ALLOW,
                                            resources=["arn:aws:route53:::hostedzone/" + dns_zone.hosted_zone_id],
                                            actions=["route53:ChangeResourceRecordSets"])]))
