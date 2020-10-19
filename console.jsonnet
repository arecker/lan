local a = import './jsonnet/ansible.jsonnet';

local params = {
  emacsVersion: 'emacs-27.1'
};

local tasks = [
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

{
  tasks: tasks,
}
