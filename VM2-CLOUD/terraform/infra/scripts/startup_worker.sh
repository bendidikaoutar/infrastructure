#!/bin/bash
exec >> /var/log/startup.log 2>&1

# Tailscale only
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up \
  --authkey=${tailscale_auth_key} \
  --hostname=${hostname} \
  --accept-routes 