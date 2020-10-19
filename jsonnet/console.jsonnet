local a = import './ansible.jsonnet';
local hosts = import './hosts.jsonnet';

local params = {
  emacsVersion: 'emacs-27.1'
};

local tasks = [
  a.Package(name='cowsay'),
  a.Package(name='fortune'),
  a.Package(name='neofetch'),
  a.Script(name='motd.sh', path='/etc/profile.d/motd.sh'),
  a.Package(name='pass'),
  a.Directory(path='~/downloads/'),
  a.Directory(path='~/src/'),
  a.GitRepo(
    url='https://git.savannah.gnu.org/git/emacs.git',
    destination='~/src/emacs',
    version=params.emacsVersion,
  ),
  a.GitRepo(
    url='git@github.com:arecker/dotfiles.git',
    destination='~/src/dotfiles'
  )
];

local playbook = [
  a.Playbook(
    name='console workstation',
    hosts=hosts.console,
    tasks=tasks,
  )
];

{
  playbook:: playbook
}
