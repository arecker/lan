local ansible = import './jsonnet/ansible.jsonnet';

local Roles = {
  all: 'all',
  kubeNodes: 'kubenodes',
};

local KubeNode(i='') = {
  role: Roles.kubeNodes,
  name: 'farm-' + std.toString(i) + '.local',
};

local main = [
  ansible.Playbook(
    name='server base',
    hosts=Roles.all,
    tasks=[
      ansible.Package(name='neofetch'),
      ansible.Script(name='motd.sh', path='/etc/profile.d/motd.sh'),
    ],
  ),
];

{
  'main.yml': std.manifestYamlStream([main]),
  'hosts.yml': std.manifestYamlDoc(ansible.HostFile([
    KubeNode(0),
    KubeNode(1),
    KubeNode(2),
    KubeNode(3),
  ])),
}
