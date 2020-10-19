local a = import './ansible.jsonnet';
local hosts = import './hosts.jsonnet';

local playbook = [
  a.Playbook(
    name='server base',
    hosts=hosts.farm,
    tasks=[
      a.Package(name='cowsay'),
      a.Package(name='fortune'),
      a.Package(name='neofetch'),
      a.Script(name='motd.sh', path='/etc/profile.d/motd.sh'),
    ],
  ),
];

{
  playbook:: playbook
}
