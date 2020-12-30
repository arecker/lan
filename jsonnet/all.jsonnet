local hosts = import './hosts.jsonnet';
local console = import './console.jsonnet';
local farm = import './farm.jsonnet';
local seedbox = import './seedbox.jsonnet';

{
  'hosts.yml': std.manifestYamlStream([hosts.inventory()]),
  'playbooks/farm.yml': std.manifestYamlStream([farm.playbook]),
  'playbooks/seedbox.yml': std.manifestYamlStream([seedbox.playbook]),
}
