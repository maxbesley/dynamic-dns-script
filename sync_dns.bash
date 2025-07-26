#!/bin/bash
# Updates the Cloudflare A record of a domain
# to the IPv4 address of the host machine.
# This is designed to be run as a cron job.


# The domain to keep updated
DOMAIN=changeme.net

# Fill these in
CF_EMAIL=example@aol.com
CF_API_KEY=
CF_ZONE_ID=
CF_DNS_RECORD_ID=


# Get the public IP of this computer
HOST_IP=$(curl -s ifconfig.me)

# Get the domain's IP over the internet
DNS_IP=$(dig +short 8.8.8.8 $DOMAIN | tail --lines=1)

# Exit quietly if the IPs match
if [ "$HOST_IP" = "$DNS_IP" ]; then
    exit 0
fi


# If here then update DNS using the Cloudflare REST API
data=(
  {
  \"name\":    \"$DOMAIN\",
  \"content\": \"$HOST_IP\",
  \"type\":    \"A\",
  \"ttl\":     600,
  \"proxied\": true
  }
)

curl https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$CF_DNS_RECORD_ID \
    -X PATCH \
    -H "Content-Type: application/json" \
    -H "X-Auth-Email: $CF_EMAIL" \
    -H "X-Auth-Key: $CF_API_KEY" \
    -d "${data[*]}" \
    &> /dev/null
