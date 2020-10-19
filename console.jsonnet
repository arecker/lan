local a = import './jsonnet/ansible.jsonnet';

local params = {
  emacsVersion: 'emacs-27.1'
};

local tasks = [
  a.Package(name='pass'),
  a.GitRepo(
    url='https://git.savannah.gnu.org/git/emacs.git',
    destination='~/src/emacs',
    version=params.emacsVersion,
  )
];

{
  tasks: tasks,
}
