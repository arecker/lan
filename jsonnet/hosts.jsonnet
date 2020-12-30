{
  seedbox: 'seedbox.local',
  farm: 'farm-[0:2:1].local',
  inventory():: (
    local hosts = [self[k] for k in std.objectFields(self)];
    {
      all: {
        hosts: {
          [host]: {}
          for host in hosts
        },
      },
    }
  ),
}
