local Roles = {
  all: 'all',
  kubeNodes: 'kube-nodes',
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

local Package(name='') = (
  local args = std.format('name="%s" state="present"', name);
  {
    name: 'install ' + name,
    package: args,
    become: true,
  }
);

local Playbook(name='', hosts='', tasks=[]) = {
  name: name,
  hosts: hosts,
  tasks: tasks,
  remote_user: 'alex',
};

local main = [
  Playbook(
    name='server base',
    hosts=Roles.all,
    tasks=[
      Package(name='neofetch'),
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
