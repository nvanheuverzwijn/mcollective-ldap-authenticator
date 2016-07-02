# mcollective-ldap-authenticator

This is an attempt to bring an ldap backend to mcollective authentication rpc.

## Install

Install everything you need for building the development box
```
$ make build
$ cd vagrant-files
$ vagrant up
```

## LDAP

LDAP files are located in `ldap.schema` folder. To generate the schema, `make ldap`.

### Samples

A sample ldif file containing data for the mcollective schema is in `ldap.schema/action-policy-sample.ldif`. Simply calling `bin/ldap-add-action-policy-sample.sh` on the vagrant box will do the trick (look in `/mcollective-ldap-authenticator` vagrant share)

## Clean

To clean the environment, `make clean`.

## Plugin configuration

```
plugin.ldapactionpolicy.allow_unconfigured = 1
plugin.ldapactionpolicy.treebase=ou=actionpolicy,ou=mcollective,dc=example,dc=com
plugin.ldapactionpolicy.host=127.0.0.1
plugin.ldapactionpolicy.port=389
plugin.ldapactionpolicy.username=cn=admin,dc=example,dc=com
plugin.ldapactionpolicy.password=asdF1234
```
