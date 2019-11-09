---

# SaltStack can't handle virtual packages or package groups
# See https://github.com/saltstack/salt/issues/47092
{% set xorg_packages = salt['cmd.shell']('pacman -Qgq xorg').split('\n') %}
{% for xorg_package in xorg_packages %}
install {{ xorg_package }} package:
  pkg.installed:
    - pkgs:
      - {{ xorg_package }}
{% endfor %}

install desktop packages:
  pkg.installed:
    - pkgs:
      - libx11
      - libxft
      - libxinerama
      - xorg-server
      - xorg-xinit
      - xorg-xsetroot
      - xorg-xrandr
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
