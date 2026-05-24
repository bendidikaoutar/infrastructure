#!/bin/bash

MASTER_IP=$(sudo tailscale status | grep "muestra-master" | awk '{print $1}');

ssh ubuntu@$MASTER_IP