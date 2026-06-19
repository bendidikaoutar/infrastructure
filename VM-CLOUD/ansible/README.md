# Ansible Configuration for EC2 instance

## Create a vault on VM1-Control

```bash
ansible-vault encrypt vault.tml
```
## Add IP to inventory.ini

Run this command to get the ip :

```bash
terraform output -raw aws_instance.vm2_ec2
```

## Run the playbook

```bash
ansible-playbook -i inventory.ini playbook-<playbook-name>.yml
```
