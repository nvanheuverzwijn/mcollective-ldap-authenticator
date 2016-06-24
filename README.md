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
