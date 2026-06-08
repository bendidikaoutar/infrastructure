#!/bin/bash

if [ -z "$1" ]; then
   echo "Error: please give a playbook name as parameter"
   exit 1
fi

set -a
source .env
set +a

if ! env | grep -q "^CLDF_"; then
    echo "Error: .env file not loaded correctly"
    exit 1
fi

INVENTORY_FILE="inventory.ini"
TERRAFORM_DIR="../terraform/infra"

cd "$TERRAFORM_DIR" || exit 1

MASTER_IP=$(terraform output -json master_private_ip | jq -r '.')
WORKER_IPS=$(terraform output -json workers_private_ips | jq -r '.[]')
WORKER_NAMES=$(terraform output -json worker_names | jq -r '.[]')

cd - > /dev/null || exit 1

mapfile -t worker_ips_array <<< "$WORKER_IPS"
mapfile -t worker_names_array <<< "$WORKER_NAMES"

{
echo "[all:vars]"
echo "ansible_user=ubuntu"
echo "ansible_ssh_private_key_file=~/.ssh/muestra"
echo "ansible_ssh_extra_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
echo
echo "[master]"
echo "master.muestra.qzz.io"
echo
echo "[master:vars]"
echo "ansible_ssh_common_args=-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='cloudflared access ssh --hostname %h --id ${CLDF_CLIENT_ID} --secret ${CLDF_CLIENT_SECRET}'"
echo
echo "[workers]"
for i in "${!worker_ips_array[@]}"; do
  name="${worker_names_array[$i]}"
  ip="${worker_ips_array[$i]}"
  echo "$name ansible_host=$ip"
done
echo
echo "[workers:vars]"
echo "ansible_ssh_common_args=-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardAgent=yes -o ProxyCommand='ssh -W %h:%p ubuntu@master.muestra.qzz.io'"
} > "$INVENTORY_FILE"

echo "Generated $INVENTORY_FILE"
echo "   - Master: master.muestra.qzz.io (tunnel SSH)"
echo "   - Workers: accès via ProxyJump depuis le master"

cd ../ansible 2>/dev/null || cd . 
ansible-playbook -i "$INVENTORY_FILE" "$1"
