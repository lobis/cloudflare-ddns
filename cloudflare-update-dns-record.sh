#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <CF_API_TOKEN> <CF_ZONE_ID> <DNS_RECORD_NAME>"
    echo "CF_API_TOKEN: Cloudflare API token"
    echo "CF_ZONE_ID: Cloudflare zone ID (can be found in the Cloudflare dashboard)"
    echo "DNS_RECORD_NAME: The DNS record name to update (e.g. record.mydomain.com)"
    exit 1
fi

CF_API_TOKEN=$1
CF_ZONE_ID=$2
DNS_RECORD_NAME=$3

PUBLIC_IP=$(curl -s https://api.ipify.org)
# Check if the IP is valid
if [[ $PUBLIC_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Public IP: $PUBLIC_IP"
else
  echo "Invalid public IP: $PUBLIC_IP"
  exit 1
fi

# Get the record ID for the record name
DNS_RECORDS=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?type=A&name=$DNS_RECORD_NAME" \
     -H "Authorization: Bearer $CF_API_TOKEN" \
     -H "Content-Type: application/json")
DNS_RECORD_ID=$(echo "$DNS_RECORDS" | grep -o '"id":"[^"]*' | awk -F'"' '{print $4}')

# Check it has correct format (32 alphanumeric characters)
if [[ $DNS_RECORD_ID =~ ^[0-9a-f]{32}$ ]]; then
  echo "DNS record ID: $DNS_RECORD_ID"
else
  echo "Invalid DNS record ID: $DNS_RECORD_ID"
  exit 1
fi

# Update A record with your public IP
curl -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$DNS_RECORD_ID" \
     -H "Authorization: Bearer $CF_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'"$DNS_RECORD_NAME"'","content":"'"$PUBLIC_IP"'","ttl":1,"proxied":false}'
