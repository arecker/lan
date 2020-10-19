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
      src: 'scripts/' + name,
      dest: path,
      owner: 'root',
      group: 'root',
      mode: '0755',
    },
  }
);

local GitRepo(url='', destination='', version='') = {
  name: 'clone repo to ' + destination,
  git: {
    repo: url,
    dest: destination,
    version: version,
  },
};

local Playbook(name='', hosts='', tasks=[]) = {
  name: name,
  hosts: hosts,
  tasks: tasks,
};

local HostFile(hosts) = (
  local roles = std.uniq([host.role for host in hosts]);
  {
    all: {
      children: {
        [role]: {
          hosts: {
            [host.name]: {
              ansible_user: host.remoteUser,
            }
            for host
            in hosts
            if host.role == role
          },
        }
        for role in roles
      },
    },
  }
);

{
  Package:: Package,
  GitRepo:: GitRepo,
  Script:: Script,
  Playbook:: Playbook,
  HostFile:: HostFile,
}
