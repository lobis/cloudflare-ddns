# cloudflare-ddns

Dynamic DNS using Cloudflare's API.

This repository contains a bash script that updates a Cloudflare DNS record with the public IP of the machine it's running on.

In order to use this script, you need to have a Cloudflare account and a domain with Cloudflare nameservers.

## Requirements

- `curl`: The script uses `curl` to make requests to the Cloudflare API.
- `grep`: The script uses `grep` to parse the response from the Cloudflare API. This is a standard Unix utility and should be available on most systems.
- `awk`: The script uses `awk` to parse the response from the Cloudflare API. This is a standard Unix utility and should be available on most systems.

## Usage

The script takes three positional arguments:

1. `CF_API_TOKEN`: Your Cloudflare API token.
2. `CF_ZONE_ID`: The ID of the zone containing the DNS record you want to update (available in the Cloudflare dashboard).
3. `DNS_RECORD_NAME`: The name of the DNS A record you want to update as a fully qualified domain name (e.g. `record.example.com`). You need to have this record already created in your Cloudflare account.

```bash
bash ./cloudflare-update-dns-record.sh $CF_API_TOKEN $CF_ZONE_ID $DNS_RECORD_NAME
```

It is recommended to make the script executable and add it to your crontab to run it periodically.

To make the script executable:

```bash
chmod +x ./cloudflare-update-dns-record.sh
```

To add the script to your crontab:

First place the script in an appropriate location, for example `/usr/local/bin/cloudflare-update-dns-record.sh`.

```bash
# Download the script to /usr/local/bin
curl -o /usr/local/bin/cloudflare-update-dns-record.sh https://raw.githubusercontent.com/lobis/cloudflare-ddns/main/cloudflare-update-dns-record.sh
```

Then open your crontab:

```bash
crontab -e
```

Add the following line to run the script every 5 minutes (replace the placeholders with your actual values):

```bash
*/5 * * * * /usr/local/bin/cloudflare-update-dns-record.sh $CF_API_TOKEN $CF_ZONE_ID $DNS_RECORD_NAME
```
