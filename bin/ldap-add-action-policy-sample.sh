#!/bin/bash

# go to script directory
cd ${0%/*}

set -v
/usr/bin/ldapadd -x -W -D 'cn=admin,dc=example,dc=com' -f ../ldap.schema/action-policy-sample.ldif
