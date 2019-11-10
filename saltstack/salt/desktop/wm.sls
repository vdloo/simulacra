---

install window manager packages:
  pkg.installed:
    - pkgs:
      - dmenu

clone dwm repo:
  git.latest:
    - user: notroot
    - target: /home/notroot/.dwm
    - branch: master
    - name: http://git.suckless.org/dwm

clean dwm build environment:
  cmd.run:
    - name: make clean
    - runas: notroot
    - cwd: /home/notroot/.dwm
    - onchanges:
      - git: clone dwm repo

make dwm:
  cmd.run:
    - name: make
    - runas: notroot
    - cwd: /home/notroot/.dwm
    - onchanges:
      - git: clone dwm repo

install dwm:
  cmd.run:
    - name: make install
    - cwd: /home/notroot/.dwm
    - onchanges:
      - git: clone dwm repo

install xdefaults:
  file.managed:
    - name: /home/notroot/.Xdefaults
    - source: salt://desktop/files/home/notroot/.Xdefaults
    - user: notroot
    - group: notroot

install xinitrc:
  file.managed:
    - name: /home/notroot/.xinitrc
    - source: salt://desktop/files/home/notroot/.xinitrc
    - user: notroot
    - group: notroot
