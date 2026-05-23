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

terraform apply -auto-approve;