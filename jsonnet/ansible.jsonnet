local Package(name='') = (
  local args = std.format('name="%s" state="present"', name);
  {
    name: 'install ' + name,
    package: args,
    become: true,
  }
);

local Script(name='', path='', user='root', group='root', mode='0755') = (
  {
    name: 'copy script ' + name,
    become: true,
    copy: {
      src: '../scripts/' + name,
      dest: path,
      owner: user,
      group: group,
      mode: mode,
    },
  }
);

local Config(name='', path='', user='', group='', mode='', notify=[]) = (
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
    notify: notify,
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
    enabled: true,
  },
};

local Playbook(name='', hosts='', tasks=[], handlers=[]) = {
  name: name,
  hosts: hosts,
  tasks: tasks,
  handlers: handlers,
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
