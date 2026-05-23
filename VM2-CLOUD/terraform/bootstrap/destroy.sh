#!/bin/bash

export $(grep -v '^#' .env | xargs);
env | grep "AWS";

if [ $? -ne 0 ]; then
    echo "Error: .env file not loaded correctly"
    exit 1
fi

terraform destroy -auto-approve;