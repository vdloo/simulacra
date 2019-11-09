---

create sudoers directory:
  file.directory:
    - name: /etc/sudoers.d
    - user: root
    - group: root
    - mode: 750

install nopassword sudoers file:
  file.managed:
    - name: /etc/sudoers.d/nopassword
    - source: salt://common/files/etc/sudoers.d/nopassword
    - user: root
    - group: root
    - mode: 440