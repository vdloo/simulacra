---

install terminal packages:
  pkg.installed:
    - pkgs:
      - terminator
	  # Terminator doesn't like the terminus system font for some reason
	  # We need to have ttf-dejavu installed to get proper rendering (in Virtualbox only?)
	  - ttf-dejavu

create config directory:
  file.directory:
    - name: /home/notroot/.config/terminator
    - user: notroot
    - group: notroot
    - makedirs: true

install terminator configuration:
  file.managed:
    - name: /home/notroot/.config/terminator/config
    - source: salt://desktop/files/home/notroot/.config/terminator/config
    - user: notroot
    - group: notroot
