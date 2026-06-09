#!/bin/bash

set -a
source .env
set +a

if ! env | grep -q "^AWS_"; then
    echo "Error: .env file not loaded correctly"
    exit 1
fi

CLDF_TUNNEL_TOKEN=$(env | grep CLDF_TUNNEL_TOKEN | cut -f 2 -d '=');
CLDF_ACCOUNT_ID=$(env | grep CLDF_ACCOUNT_ID | cut -f 2 -d '=');
CLDF_ZONE_ID=$(env | grep CLDF_ZONE_ID | cut -f 2 -d '=');
CLDF_TUNNEL_ID=$(env | grep CLDF_TUNNEL_ID | cut -f 2 -d '=');
CLDF_API_TOKEN=$(env | grep CLDF_API_TOKEN | cut -f 2 -d '=');
DB_PASSWORD=$(env | grep DB_PASSWORD | cut -f 2 -d '=');


terraform output;