local a = import './ansible.jsonnet';
local hosts = import './hosts.jsonnet';

local params = {};

local UpdateTransmissionHandler = {
  name: 'update transmission service',
  script: '../scripts/update-transmission.sh',
  become: true,
};

local UpdateOpenVPNHandler = {
  name: 'update openvpn service',
  become: true,
  service: {
    name: 'openvpn',
    state: 'restarted',
  },
};

local ReloadFirewallHandler = {
  name: 'reload firewall',
  become: true,
  service: {
    name: 'ipfw',
    state: 'restarted',
  },
};

local openVPNTasks = [
  a.Package(name='openvpn'),
] + [
  a.Config(
    name='openvpn/' + name,
    path='/usr/local/etc/openvpn/' + name,
    user='root',
    group='wheel',
    mode='0644',
    notify=[UpdateOpenVPNHandler.name]
  )
  for name in ['openvpn.conf', 'ca.rsa.2048.crt', 'crl.rsa.2048.pem', 'pass.txt']
] + [
  a.Service(name='openvpn'),
];

local transmissionTasks = [
  a.Package(name='transmission-cli'),
  a.Package(name='transmission-daemon'),
  a.Package(name='transmission-web'),
  a.Config(
    name='transmission.json',
    path='/usr/local/etc/transmission/home/settings.latest.json',
    user='transmission',
    group='transmission',
    mode='0600',
    notify=[UpdateTransmissionHandler.name]
  ),
  {
    name: 'start transmission service',
    become: true,
    service: {
      name: 'transmission',
      state: 'started',
      enabled: false,
    },
  },

];

local firewallTasks = [
  {
    name: 'copy ipfw.rules',
    become: true,
    notify: [ReloadFirewallHandler.name],
    copy: {
      src: '../scripts/ipfw.rules',
      dest: '/etc/ipfw.rules',
      owner: 'root',
      group: 'wheel',
      mode: '0770',
    },
  },
  {
    name: 'start ipfw service',
    become: true,
    service: {
      name: 'ipfw',
      state: 'started',
      enabled: true,
    },
  },
];

local mountTasks = [
  {
    name: 'start nfsclient service',
    become: true,
    service: {
      name: 'nfsclient',
      state: 'started',
      enabled: true,
    },
  },
  {
    name: 'mount downloads directory on boot',
    become: true,
    mount: {
      path: '/usr/local/etc/transmission/home/Downloads',
      src: 'nas.local:/volume1/downloads',
      fstype: 'nfs',
      opts: 'rw,nfsv4',
      state: 'mounted',
    },
  },
];

local playbook = [
  a.Playbook(
    name='seedbox',
    hosts=hosts.seedbox,
    tasks=[
      a.Package(name='bash'),
      a.Package(name='nano'),
      {
        name: 'copy rc.conf',
        become: true,
        copy: {
          src: '../configs/rc.conf',
          dest: '/etc/rc.conf',
          owner: 'root',
          group: 'wheel',
          mode: '0644',
        },
      },
    ] + mountTasks + openVPNTasks + transmissionTasks + firewallTasks,
    handlers=[
      ReloadFirewallHandler,
      UpdateOpenVPNHandler,
      UpdateTransmissionHandler,
    ]
  ),
];

{
  playbook:: playbook,
}
