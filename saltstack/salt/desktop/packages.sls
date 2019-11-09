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
