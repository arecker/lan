local a = import './ansible.jsonnet';
local hosts = import './hosts.jsonnet';

local params = {
  emacsVersion: 'emacs-27.1',
};

local tasks = [
  {
    name: 'install packages',
    become: true,
    package: {
      name: '{{ item }}',
      state: 'present',
    },
    with_items: [
      'cowsay',
      'fortune',
      'neofetch',
      'pass',
    ],
  },
  {
    name: 'make directories',
    file: {
      path: '{{ item }}',
      state: 'directory',
      mode: '0754',
    },
    with_items: [
      '~/downloads',
      '~/src',
    ]
  },
  a.Script(name='motd.sh', path='/etc/profile.d/motd.sh'),
  a.GitRepo(
    url='https://git.savannah.gnu.org/git/emacs.git',
    destination='~/src/emacs',
    version=params.emacsVersion,
  ),
  a.GitRepo(
    url='git@github.com:arecker/dotfiles.git',
    destination='~/src/dotfiles'
  ),
];

local playbook = [
  a.Playbook(
    name='console workstation',
    hosts=hosts.console,
    tasks=tasks,
  ),
];

{
  playbook:: playbook,
}
