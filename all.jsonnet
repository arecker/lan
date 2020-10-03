local ansible = import './jsonnet/ansible.jsonnet';

local Roles = {
  all: 'all',
  kubeNodes: 'kubenodes',
  list():: (
    [
      self[k]
      for k
      in std.objectFields(self)
      if k != 'all'
    ]
  ),
};

local KubeNode(i='') = {
  role: Roles.kubeNodes,
  name: 'farm-' + std.toString(i) + '.local',
};

local hosts = [
  KubeNode(0),
  KubeNode(1),
  KubeNode(2),
  KubeNode(3),
];

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
  'hosts.yml': std.manifestYamlDoc(
    (
      {
        all: {
          children: {
            [role]: {
              hosts: {
                [host.name]: {}
                for host
                in hosts
                if host.role == role
              },
            }
            for role in Roles.list()
          },
        },
      }
    ),
  ),
}
