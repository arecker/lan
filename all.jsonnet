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

local Package(name='') = (
  local args = std.format('name="%s" state="present"', name);
  {
    name: 'install ' + name,
    package: args,
    become: true,
  }
);

local Script(name='', path='') = (
  {
    name: 'copy script ' + name,
    become: true,
    copy: {
      src: "scripts/" + name,
      dest: path,
      owner: 'root',
      group: 'root',
      mode: '0755'
    }
  }
);

local Playbook(name='', hosts='', tasks=[]) = {
  name: name,
  hosts: hosts,
  tasks: tasks,
};

local main = [
  Playbook(
    name='server base',
    hosts=Roles.all,
    tasks=[
      Package(name='neofetch'),
      Script(name='motd.sh', path='/etc/profile.d/motd.sh'),
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
