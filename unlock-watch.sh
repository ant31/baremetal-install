#!/bin/bash

while true; do
    ansible-playbook -i inventory/production unlock.yaml -u connyadmin --tags unlock -l $1 --private-key=roles/hetzner/os-config/dropbear/files/id_rsa.hetzner-dropbear.key
    echo "SLEEP 10"
    sleep 10
done
