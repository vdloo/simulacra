---

install common packages:
  pkg.installed:
    - pkgs:
      - python-virtualenv
      - unzip
      - curl
      - wget
      - nmap
      - automake
      - make
      - htop
      - iftop
      - sysstat
      - task
      - irssi
      - ctags
      - git
      - screen
      - xclip
      - strace
      - feh
      - sudo
    - refresh: true

# SaltStack can't handle virtual packages or package groups
# See https://github.com/saltstack/salt/issues/47092
{% set base_devel_packages = salt['cmd.shell']('pacman -Qgq base-devel').split('\n') %}
{% for base_devel_package in base_devel_packages %}
install {{ base_devel_package }} package:
  pkg.installed:
    - pkgs:
      - {{ base_devel_package }}
{% endfor %}
