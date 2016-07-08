all:
	@echo "usage: make build"
	@echo "       make clean"
	@echo "       make ldap"
	@echo "       make vagrant"

build:
	./bin/make_script/make_build.sh

ldap: 
	./bin/make_script/make_ldap.sh

clean:
	./bin/make_script/make_clean.sh

vagrant:
	./bin/make_script/make_vagrant.sh
