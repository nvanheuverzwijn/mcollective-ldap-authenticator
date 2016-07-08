#!/bin/bash

cd vagrant-files
vagrant ssh -c "sudo /mcollective-ldap-authenticator/tests/ldap.sh"
