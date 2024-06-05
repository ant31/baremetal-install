import argparse
import yaml

def _ssh_config(servers, sshuser):
    conf = []
    for k, s in servers.items():
        names = [s['name']]
        if k != s['name']:
            names.append(k)
        print(names, k)
        for hostname in names:
            template = """
#{hostname}
Host {host}
    HostName {ip}
    User {sshuser}
    IdentityFile ~/.ssh/id_rsa
""".format(hostname=s['hostname'],
           host=hostname,
           sshuser=sshuser,
           ip=s['ansible_ssh_host'],
           )
        conf.append(template)
    return conf

def ssh_config(env: str, sshuser: str) -> None:
    with open(f'inventory/{env}/hosts.yaml', 'r') as f:
        inventory = yaml.safe_load(f.read())
    configs = _ssh_config(inventory['all']['hosts'], sshuser)
    with open(f'inventory/{env}/cloud.yaml', 'r') as f:
        inventory_cloud = yaml.safe_load(f.read())
    if 'all' in inventory_cloud and 'hosts' in inventory_cloud['all']:
        configs += _ssh_config(inventory_cloud['all']['hosts'], sshuser)
    with open(f'config-{env}', 'w') as f:
        for c in configs:
            f.write(c + "\n")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', "--inventory", help="inventory", default="kubespray")
    parser.add_argument('-u', "--ssh-user", help="ssh user", default="kadmin")
    args = parser.parse_args()
    ssh_config(args.inventory, args.ssh_user)

main()
