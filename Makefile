.PHONY: all clean

NAME := simulacra
VERSION := 0.1
MAINTAINER := Rick van de Loo <rickvandeloo@gmail.com>
DESCRIPTION := My personal decentralized grid computing cluster

test:
	./runtests.sh -1
install:
	mkdir -p /usr/share/simulacra
	rm -rf /usr/share/simulacra/.venv
	cp -R . /usr/share/simulacra
	ln -sf /usr/share/simulacra/bin/jobrunner /usr/bin/jobrunner
	chmod u+x /usr/bin/jobrunner
uninstall:
	rm -rf /usr/share/simulacra
	rm -f /usr/bin/jobrunner
clean:
	git clean -xfd

