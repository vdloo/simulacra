---

install locale.gen:
  file.managed:
    - name: /etc/locale.gen
    - source: salt://common/files/etc/locale.gen
    - user: root
    - group: root
    - mode: 644

install locale:
  file.managed:
    - name: /etc/default/locale
    - source: salt://common/files/etc/locale
    - user: root
    - group: root
    - mode: 644

generate locales:
  cmd.run:
    - name: locale-gen
    - listen:
      - file: /etc/locale.gen
