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

local Directory(path='', mode='0754') = {
  name: 'create directory ' + path,
  file: {
    path: path,
    state: 'directory',
    mode: mode,
  },
};

local GitRepo(url='', destination='', version='master') = {
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
  Directory:: Directory,
  GitRepo:: GitRepo,
  HostFile:: HostFile,
  Package:: Package,
  Playbook:: Playbook,
  Script:: Script,
}
