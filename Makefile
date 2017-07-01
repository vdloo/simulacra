.PHONY: all clean

NAME := simulacra
VERSION := 0.1
MAINTAINER := Rick van de Loo <rickvandeloo@gmail.com>
DESCRIPTION := My personal decentralized grid computing cluster

test:
	./runtests.sh -1
install:
	sudo mkdir -p /usr/share/simulacra
	sudo cp -R . /usr/share/simulacra
	sudo ln -sf /usr/share/simulacra/bin/jobrunner /usr/bin/jobrunner
	sudo chmod u+x /usr/bin/jobrunner
uninstall:
	sudo rm -rf /usr/share/simulacra
	sudo rm -f /usr/bin/jobrunner
clean:
	git clean -xfd

