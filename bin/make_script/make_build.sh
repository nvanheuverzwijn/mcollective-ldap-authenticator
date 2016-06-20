#!/bin/bash

# package manager detection
if command -v pacman >/dev/null 2>&1; then
  echo "> Package manager 'pacman' detected"
  package_install='sudo pacman --noconfirm -S'
  package_ruby_bundler='ruby-bundler'
elif command -v apt-get >/dev/null 2>&1; then
  echo "> Package manager 'apt-get' detected"
  install_package='sudo apt-get install -y'
  package_ruby_bundler='bundler'
fi

# installing required package
if ! command -v bundler >/dev/null 2>&1; then
  echo "> Package '$package_ruby_bundler' is not installed. Installing now" 1>&2
  echo "$package_install $package_ruby_bundler"
  $package_install $package_ruby_bundler
fi

echo "> Bundle install" 1>&2
bundle install

echo "> Librarian-puppet install" 1>&2
cd puppet-files && bundle exec librarian-puppet install


echo "> Installation complete"
