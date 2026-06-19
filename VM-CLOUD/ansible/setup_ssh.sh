#!/bin/bash

set -a
source .env
set +a

if ! env | grep -q "^CLDF_"; then
    echo "Error: .env file not loaded correctly"
    exit 1
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

ssh-add ~/.ssh/muestra 2>/dev/null || true

CLDF_CLIENT_ID=$(env | grep CLDF_CLIENT_ID | cut -f 2 -d '=');
CLDF_CLIENT_SECRET=$(env | grep CLDF_CLIENT_SECRET | cut -f 2 -d '=');

SSH_CONFIG="$HOME/.ssh/config"
MARKER_START="# BEGIN muestra-master"
MARKER_END="# END muestra-master"

if grep -q "$MARKER_START" "$SSH_CONFIG" 2>/dev/null; then
    sed -i "/$MARKER_START/,/$MARKER_END/d" "$SSH_CONFIG"
fi

cat >> "$SSH_CONFIG" << EOF

$MARKER_START
Host master.muestra.qzz.io
  ProxyCommand cloudflared access ssh --hostname %h --id ${CLDF_CLIENT_ID} --secret ${CLDF_CLIENT_SECRET}
  User ubuntu
  IdentityFile ~/.ssh/muestra
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
$MARKER_END
EOF

chmod 600 "$SSH_CONFIG"

ssh master.muestra.qzz.io "echo '$(cat ~/.ssh/muestra_ci.pub)' >> ~/.ssh/authorized_keys"

echo "SSH config updated"
echo ""
echo "Now you can connect with:"
echo "  ssh master.muestra.qzz.io"
echo ""