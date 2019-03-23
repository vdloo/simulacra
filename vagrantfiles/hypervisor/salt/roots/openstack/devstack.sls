https://github.com/openstack-dev/devstack:
  git.latest:
    - target: /opt/devstack
    - branch: stable/rocky

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
    - template: jinja
    - defaults:
        custom_var: "default value"
        other_var: 123

/bin/chown stack:stack /opt/devstack:
  cmd.run

/opt/devstack/stack.sh > /tmp/devstackbootstrap.log 2>&1:
  cmd.run:
    - runas: stack
