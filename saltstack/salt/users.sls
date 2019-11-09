---

install not root user:
  user.present:
    - name: notroot
    - fullname: Not Root
    - password: notroot

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
