all:
	@echo "usage: make build"
	@echo "       make clean"
	@echo "       make ldap"
build:
	./bin/make_script/make_build.sh

ldap: 
	./bin/make_script/make_ldap.sh

clean:
	./bin/make_script/make_clean.sh
