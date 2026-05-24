#!/bin/bash

if [ -z "$1" ]; then
   echo "Error: please give a playbook name as parameter"
   exit 1
fi

INVENTORY_FILE="inventory.ini"
TERRAFORM_DIR="../terraform/infra"

MASTER=$(sudo tailscale status | grep "muestra-master");
MASTER_HOSTNAME=$(echo "$MASTER" | awk '{print $2}');
MASTER_IP=$(echo "$MASTER" | awk '{print $1}');

mapfile -t WORKER_IPS < <(
  cd "$TERRAFORM_DIR" &&
  set -a
  source .env
  set +a
  terraform output -json worker_private_ips | jq -r '.[]'
)

mapfile -t WORKER_NAMES < <(
  cd "$TERRAFORM_DIR" && 
  set -a
  source .env
  set +a
  terraform output -json worker_names | jq -r '.[]'
)

{

echo "[master]"
echo "$MASTER_HOSTNAME ansible_host=$MASTER_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa"

echo
echo "[workers]"

for i in "${!WORKER_IPS[@]}"; do
  IP="${WORKER_IPS[$i]}"
  HOSTNAME="${WORKER_NAMES[$i]}"
  
  echo "$HOSTNAME ansible_host=$IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa"
done

echo
echo "[workers:vars]"
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyJump=ubuntu@$MASTER_IP -o ForwardAgent=yes'" 
echo
echo "[master:vars]"
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"

} > "$INVENTORY_FILE"

echo "Generated $INVENTORY_FILE"

ansible-playbook -i $INVENTORY_FILE $1
