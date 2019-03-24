https://github.com/vdloo/devstack:
  git.latest:
    - target: /opt/devstack
    - branch: stable/rocky

net.ipv6.conf.all.disable_ipv6:
  sysctl.present:
    - value: 0

/opt/devstack/tools/create-stack-user.sh:
  cmd.run

/bin/chown -R stack:stack /opt/devstack:
  cmd.run

/opt/devstack/.localrc.password:
  file.managed:
    - source: salt://openstack/files/.localrc.password
    - user: stack
    - group: stack
    - mode: 644

/bin/chown stack:stack /opt/devstack:
  cmd.run

/opt/devstack/stack.sh > /tmp/devstackbootstrap.log 2>&1:
  cmd.run:
    - runas: stack
