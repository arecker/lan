local ansible = import './jsonnet/ansible.jsonnet';
local console = import './console.jsonnet';
local seedbox = import './seedbox.jsonnet';

local Host = {
  remoteUser: 'alex',
};

local KubeNode(i='') = Host {
  role: 'kubenodes',
  name: 'farm-' + std.toString(i) + '.local',
};

local main = [
  ansible.Playbook(
    name='server base',
    hosts='all',
    tasks=[
      ansible.Package(name='cowsay'),
      ansible.Package(name='fortune'),
      ansible.Package(name='neofetch'),
      ansible.Script(name='motd.sh', path='/etc/profile.d/motd.sh'),
    ],
  ),
];

local consolePlaybook = [
  ansible.Playbook(
    name='console workstation',
    hosts='console',
    tasks=console.tasks,
  ),
];

local Console() = Host {
  role: 'personal',
  name: 'console'
};

local seedboxPlaybook = [
  ansible.Playbook(
    name='seedbox',
    hosts='seedbox',
    tasks=seedbox.tasks,
  ),
];

local Seedbox() = Host {
  role: 'seedbox',
  name: 'seedbox'
};

{
  'main.yml': std.manifestYamlStream([main]),
  'console.yml': std.manifestYamlStream([consolePlaybook]),
  'seedbox.yml': std.manifestYamlStream([seedboxPlaybook]),
  'hosts.yml': std.manifestYamlDoc(ansible.HostFile([
    KubeNode(0),
    KubeNode(1),
    KubeNode(2),
    Seedbox(),
    Console(),
  ])),
}
