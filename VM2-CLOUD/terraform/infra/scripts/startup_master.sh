#!/bin/bash
exec > /var/log/startup.log 2>&1

# Install tailscale
curl -fsSL https://tailscale.com/install.sh | sh

tailscale up \
 --authkey=${tailscale_auth_key} \
 --hostname=${hostname} \
 --accept-routes 

# Install cloudflared
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | gpg --dearmor -o /usr/share/keyrings/cloudflare-main.gpg

echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared focal main" | tee /etc/apt/sources.list.d/cloudflared.list

apt-get update && apt-get install -y cloudflared

cloudflared service install ${cloudflare_tunnel_token}
systemctl enable cloudflared
systemctl start cloudflared