#!/bin/bash

set -a
source .env
set +a

if ! env | grep -q "^AWS_"; then
    echo "Error: .env file not loaded correctly"
    exit 1
fi

if [ ! -d './.terraform' ]; then
    terraform init;
fi

CLDF_TUNNEL_TOKEN=$(env | grep CLDF_TUNNEL_TOKEN | cut -f 2 -d '=');
CLDF_ACCOUNT_ID=$(env | grep CLDF_ACCOUNT_ID | cut -f 2 -d '=');
CLDF_ZONE_ID=$(env | grep CLDF_ZONE_ID | cut -f 2 -d '=');
CLDF_TUNNEL_ID=$(env | grep CLDF_TUNNEL_ID | cut -f 2 -d '=');
CLDF_API_TOKEN=$(env | grep CLDF_API_TOKEN | cut -f 2 -d '=');
DB_PASSWORD=$(env | grep DB_PASSWORD | cut -f 2 -d '=');


terraform apply \
    -var="cloudflare_tunnel_token=${CLDF_TUNNEL_TOKEN}" \
    -var="cloudflare_account_id=${CLDF_ACCOUNT_ID}" \
    -var="cloudflare_zone_id=${CLDF_ZONE_ID}" \
    -var="cloudflare_tunnel_id=${CLDF_TUNNEL_ID}" \
    -var="cloudflare_api_token=${CLDF_API_TOKEN}" \
    -var="db_password=${DB_PASSWORD}" \
    -auto-approve;