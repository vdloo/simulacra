---

install not root user:
  user.present:
    - name: notroot
    - fullname: Not Root
    # notroot
    - password: $6$Fa4ELMtlTwOvhG50$JNbroT9R1Bj0QvER7PYw3Zxn2pnuA/uvj7obVJx0RXauLytV0xecEawUxKRhRaiIfjDWp1dn9tpCKoVd2OEBy/

ensure git email is configured:
  git.config_set:
    - name: user.email
    - value: notroot@example.com
    - user: notroot
    - global: True

ensure git username is configured:
  git.config_set:
    - name: user.name
    - value: notroot
    - user: notroot
    - global: True

ensure git editor is configured:
  git.config_set:
    - name: core.editor
    - value: vim
    - user: notroot
    - global: True
