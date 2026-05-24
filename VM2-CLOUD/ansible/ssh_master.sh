#!/bin/bash

set -a
source .env
set +a

if ! env | grep -q "^CLDF_"; then
    echo "Error: .env file not loaded correctly"
    exit 1
fi

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
  IdentityFile ~/.ssh/id_rsa
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
$MARKER_END
EOF

chmod 600 "$SSH_CONFIG"

echo "SUCCESS: ~/.ssh/config updated"
echo "Connecting to master.muestra.qzz.io"

ssh master.muestra.qzz.io