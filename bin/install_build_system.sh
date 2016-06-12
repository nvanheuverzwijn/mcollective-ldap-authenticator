#!/usr/bin/bash

# package manager detection
if command -v pacman >/dev/null 2>&1; then
  echo "> Package manager 'pacman' detected"
  package_install='sudo pacman --noconfirm -S'
  package_ruby_bundler='ruby-bundler'
  package_puppet='puppet'
elif command -v apt-get >/dev/null 2>&1; then
  echo "> Package manager 'apt-get' detected"
  install_package='sudo apt-get install -y'
  package_ruby_bundler='bundler'
  package_puppet='puppet'
fi

# installing required package
if ! command -v bundler >/dev/null 2>&1; then
  echo "> Package '$package_ruby_bundler' is not installed. Installing now" 1>&2
  echo "$package_install $package_ruby_bundler"
  $package_install $package_ruby_bundler
fi

if ! command -v puppet >/dev/null 2>&1; then
  echo "> Package '$package_puppet' is not installed. Installing now" 1>&2
  echo "$package_install $package_puppet"
  $package_install $package_puppet
fi

echo "> Installation complete"
