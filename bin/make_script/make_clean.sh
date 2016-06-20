#!/bin/bash

echo "Cleaning librarian puppet installation modules" 1>&2
cd puppet-files && bundle exec librarian-puppet clean # removing puppet-files modules

echo "Cleaning bundle installation" 1>&2
bundle clean && rm -rf ruby # removing bundle install
