# VM2-TEST

> Those playbook are only meant to be used with **Ubuntu** based distros. \
> You need to have **ansible** installed in order to use those playbooks.

## Configuration

Rename the file [inventory.example.ini](./inventory.example.ini) to **inventory.ini** then specify the ip of the VM and the username 

```ini
[devsecops]

x.x.x.x ansible_user=<user_name>

```

## Run 

To run a specific playbook, you can use the command below :

```bash

ansible-playbook -i inventory.ini <playbook_file_name>.yml --ask-become-pass

```
Please confirm with the password of the **user_name** you mentionned above.

## Playbooks

- *playbook-docker* : add docker repo and install docker on the VM
- *playbook-gitlab-up* : copy [./docker/docker-compose-gitlab.yml](./docker/docker-compose-gitlab.yml) to **/opt/gitlab-stack** then start the gitlab stack
- *playbook-gitlab-down* : stop gitlab stack