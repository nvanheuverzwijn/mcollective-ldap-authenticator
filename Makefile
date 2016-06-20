all:
	@echo "usage: make build"
	@echo "       make clean"
	@echo "       make ldap"
build:
	./bin/install_build_system.sh
	bundle install
	cd puppet-files && bundle exec librarian-puppet install

ldap: 
	./bin/make_script/make_ldap_schema.sh

clean:
	cd puppet-files && bundle exec librarian-puppet clean # removing puppet-files modules
	bundle clean && rm -rf ruby # removing bundle install
