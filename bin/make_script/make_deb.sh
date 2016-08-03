#!/bin/bash

mkdir package
VERSION=$(cat VERSION)

bundle exec fpm -s dir -t deb -v "$VERSION" -n "mcollective-ldap-action-policy" \
--deb-priority "optional" \
--directories "/usr/share/doc/mcollective-ldap-action-policy/ " \
--maintainer "Nicolas Vanheuverzwijn <nicolas.vanheu@gmail.com>" \
--url "https://github.com/nvanheuverzwijn/mcollective-ldap-authenticator" \
--vendor "Nicolas Vanheuverzwijn" \
--architecture "all" \
--package "./package/" \
--deb-no-default-config-files \
--description "mcollective ldap authentication backend" \
'ldap.schema/action-policy.schema=usr/share/doc/mcollective-ldap-action-policy/' \
'util/ldapactionpolicy.ddl=usr/share/mcollective/plugins/mcollective/util/' \
'util/ldapactionpolicy.rb=usr/share/mcollective/plugins/mcollective/util/'

