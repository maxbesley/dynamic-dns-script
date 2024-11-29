#!/bin/sh
# Updates the AWS Route 53 'A' record of a domain
# to the IPv4 address of the host machine.
# This is designed to be run as a cron job.


DOMAIN=changeme.com

# Get the public IP of this computer
HOST_IP=$(curl -s ifconfig.me)

# Query the domain over the public internet
DNS_IP=$(dig +short 8.8.8.8 $DOMAIN | tail --lines=1)

# Exit quietly if the IPs match
if [ "$HOST_IP" = "$DNS_IP" ]; then
    exit
fi


# If here then update DNS through the AWS API

JSON="{\"Changes\": [{\"Action\": \"UPSERT\",\"ResourceRecordSet\": {\"Name\": \"$(eval 'echo $DOMAIN')\",\"Type\": \"A\",\"TTL\": 300,\"ResourceRecords\": [{\"Value\": \"$(eval 'echo $HOST_IP')\"}]}}]}"

ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='$(eval "echo $DOMAIN").'].Id" --output text)

aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch "$JSON" > /dev/null
