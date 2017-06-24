.PHONY: all clean

NAME := simulacra
VERSION := 0.1
MAINTAINER := Rick van de Loo <rickvandeloo@gmail.com>
DESCRIPTION := My personal decentralized grid computing cluster

test:
	./runtests.sh -1
install:
	chmod u+x setup.sh
	./setup.sh
clean:
	git clean -xfd

