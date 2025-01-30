#!/bin/bash
echo $1
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o 'User=root' -o ConnectTimeout=10 -tt root@$1 'echo -n $CRYPTROOT_KEY | cryptroot-unlock'
