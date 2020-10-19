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
      src: '../scripts/' + name,
      dest: path,
      owner: 'root',
      group: 'root',
      mode: '0755',
    },
  }
);

local Config(name='', path='', user='', group='', mode='') = (
  {
    name: 'copy config ' + name,
    become: true,
    copy: {
      src: '../configs/' + name,
      dest: path,
      owner: user,
      group: group,
      mode: mode,
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

local Service(name='') = {
  name: 'start service ' + name,
  become: true,
  service: {
    name: name,
    state: 'started',
    enabled: true
  }
};

local Playbook(name='', hosts='', tasks=[]) = {
  name: name,
  hosts: hosts,
  tasks: tasks,
};

{
  Directory:: Directory,
  GitRepo:: GitRepo,
  Package:: Package,
  Playbook:: Playbook,
  Script:: Script,
  Service:: Service,
  Config:: Config,
}
