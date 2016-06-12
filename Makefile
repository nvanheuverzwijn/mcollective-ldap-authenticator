all:
	@echo "usage: make build"
	@echo "       make clean"
build:
	./bin/install_build_system.sh
	bundle install
	cd puppet-files && bundle exec librarian-puppet install
clean:
	cd puppet-files && bundle exec librarian-puppet clean # removing puppet-files modules
	bundle clean && rm -rf ruby # removing bundle install
