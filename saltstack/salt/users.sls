---

install not root user:
  user.present:
    - name: notroot
    - fullname: Not Root
    - password: notroot
