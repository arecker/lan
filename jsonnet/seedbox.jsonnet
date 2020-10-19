local a = import './ansible.jsonnet';
local hosts = import './hosts.jsonnet';

local params = {};

local openVPNTasks = [
  a.Package(name='openvpn'),
] + [
  a.Config(
    name='openvpn/' + name,
    path='/usr/local/etc/openvpn/' + name,
    user='root',
    group='wheel',
    mode='0644'
  ) for name in ['openvpn.conf', 'ca.rsa.2048.crt', 'crl.rsa.2048.pem', 'pass.txt']
] + [
  a.Service(name='openvpn')
];

local playbook = [
  a.Playbook(
    name='seedbox',
    hosts=hosts.seedbox,
    tasks=[
      a.Package(name='bash'),
    ] + openVPNTasks,
  ),
];

{
  playbook:: playbook,
}
