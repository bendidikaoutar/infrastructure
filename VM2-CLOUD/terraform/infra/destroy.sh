#!/bin/bash

set -a
source .env
set +a

if ! env | grep -q "^AWS_"; then
    echo "Error: .env file not loaded correctly"
    exit 1
fi

TS_KEY=$(env | grep TS_KEY | cut -f 2 -d '=');
CLDF_KEY=$(env | grep CLDF_TOKEN | cut -f 2 -d '=');

terraform destroy \
    -var="tailscale_auth_key=${TS_KEY}" \
    -var="cloudflare_tunnel_token=${CLDF_KEY}" \
    -auto-approve;