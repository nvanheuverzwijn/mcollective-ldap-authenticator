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

## Clean

To clean the environment, `make clean`.

## Plugin configuration

```
plugin.ldapactionpolicy.allow_unconfigured = 1
plugin.ldapactionpolicy.treebase=ou=actionpolicy,ou=mcollective,dc=example,dc=com # Location of the action policy
plugin.ldapactionpolicy.host=127.0.0.1
plugin.ldapactionpolicy.port=389
plugin.ldapactionpolicy.username=cn=admin,dc=example,dc=com
plugin.ldapactionpolicy.password=asdF1234
```
