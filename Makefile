INVENTORY ?= inventory/kubespray
ADMIN=kadmin
update-inventory:
	echo "TODO generate inventory from equinix API"


configure-new-servers-ssh:
	ansible-playbook -i $(INVENTORY)  playbook-install.yaml -u root -e ansible_ssh_user=root -e reboot=no -l status_inrescue -e release_upgrade=false -t ssh-auth  $(EXTRA)

configure-new-servers:
	ansible-playbook -i $(INVENTORY)  playbook-install.yaml --become --become-user=root -u $(ADMIN) -e ansible_ssh_user=$(ADMIN) -e reboot=no -l status_inrescue -e release_upgrade=false -vv $(EXTRA)

configure-servers:
	ansible-playbook -i $(INVENTORY)  playbook-install.yaml -u $(ADMIN) --become --become-user=root  -e reboot=no -l $(GROUP) $(TAGS) $(EXTRA)

# Usage: make configure-ssh-access GROUP=all
# Redeploy ssh-keys as configured in inventory/group_vars/all/hetzner.yaml
configure-ssh-access:
	ansible-playbook -i $(INVENTORY)  playbook-install.yaml -u $(ADMIN) --become --become-user=root  -e reboot=no -t ssh-auth -l $(GROUP) $(EXTRA)

configure-network:
	ansible-playbook -i $(INVENTORY) -u $(ADMIN) playbook-install.yaml --become --become-user=root  -e reboot=always  -e reset=false  -vv  --tags netplan -l $(GROUP)


reboot:
	ansible-playbook -i $(INVENTORY) -u $(ADMIN) playbook-install.yaml --become --become-user=root  -e reboot=always  -e reset=false  -vv  --tags reboot -l $(GROUP) $(EXTRA)

unlock:
	ansible-playbook -i $(INVENTORY) unlock.yaml -u $(ADMIN) -vv  --tags unlock -l $(GROUP) $(EXTRA)

check:
	ansible-playbook -i $(INVENTORY) check.yaml --become --become-user=root -u $(ADMIN) -vv -e ansible_python_interpreter=/usr/bin/python3 $(EXTRA)

release-upgrade:
	ansible-playbook -i $(INVENTORY)  playbook-install.yaml -b --become-user=root -e ansible_ssh_user=$(ADMIN) -e reboot=no -l $(GROUP)  -e release_upgrade=true --tags release-upgrade $(EXTRA)

os-upgrade-rolling:
	ansible-playbook -i $(INVENTORY)  rolling-upgrade.yaml -u $(ADMIN)   -b --become-user=root -l $(GROUP) $(OPTIONS)

ferm-rules-update:
	ansible-playbook -i $(INVENTORY)  playbook-install.yaml -u $(ADMIN) --become --become-user=root  -t ferm -e reboot=no -l $(GROUP) $(TAGS) $(EXTRA)
