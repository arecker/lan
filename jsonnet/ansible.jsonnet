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

{
  Package:: Package,
  Script:: Script,
  Playbook:: Playbook,
}
