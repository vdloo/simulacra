---

install vim packages:
  pkg.installed:
    - pkgs:
      - vim

install vimrc:
  file.managed:
    - name: /home/notroot/.vimrc
    - source: salt://common/files/home/notroot/.vimrc
    - user: notroot
    - group: notroot

create vim directory:
  file.directory:
    - name: /home/notroot/.vim
    - user: notroot
    - group: notroot

create vundle bundle directory:
  file.directory:
    - name: /home/notroot/.vim/bundle
    - user: notroot
    - group: notroot

install vundle:
  git.latest:
    - user: notroot
    - target: /home/notroot/.vim/bundle/Vundle
    - branch: master
    - name: https://github.com/VundleVim/Vundle.vim

install vim plugins:
  cmd.run:
    - name: vim +PluginInstall +qall &>/dev/null
    - runas: notroot

create vim colors directory:
  file.directory:
    - name: /home/notroot/.vim/colors
    - user: notroot
    - group: notroot

install zenburn theme:
  file.managed:
    - name: /home/notroot/.vim/colors/zenburn.vim
    - source: salt://common/files/home/notroot/.vim/colors/zenburn.vim
    - user: notroot
    - group: notroot
