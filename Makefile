all: build ldap vagrant test

help:
	@echo "usage: make build"
	@echo "       make clean"
	@echo "       make ldap"
	@echo "       make test"
	@echo "       make vagrant"

build:
	./bin/make_script/make_build.sh

ldap: 
	./bin/make_script/make_ldap.sh

clean:
	./bin/make_script/make_clean.sh

test:
	./bin/make_script/make_tests.sh

vagrant:
	./bin/make_script/make_vagrant.sh
