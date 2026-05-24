#!/bin/bash

if [ -z "$1" ]; then
   echo "Error: please give a playbook name as parameter"
   exit 1
fi

INVENTORY_FILE="inventory.ini"

MASTER=$(sudo tailscale status | grep "muestra-master");
MASTER_HOSTNAME=$(echo "$MASTER" | awk '{print $2}');
MASTER_IP=$(echo "$MASTER" | awk '{print $1}');

mapfile -t WORKERS < <(
  sudo tailscale status | grep "muestra-node-" | sort -k2
)

{

echo "[master]"
echo "$MASTER_HOSTNAME ansible_host=$MASTER_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa"

echo
echo "[workers]"

for worker in "${WORKERS[@]}"; do
  IP=$(echo "$worker" | awk '{print $1}')
  HOSTNAME=$(echo "$worker" | awk '{print $2}')
  
  echo "$HOSTNAME ansible_host=$IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa"
done

echo
echo "[all:vars]"
echo "ansible_ssh_common_args='-o StricthostKeyChecking=no'" 

} > "$INVENTORY_FILE"

echo "Generated $INVENTORY_FILE"

ansible-playbook -i $INVENTORY_FILE $1
