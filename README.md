# mcollective-ldap-authenticator

This is an attempt to implement the [mcollective action policy project](https://github.com/puppetlabs/mcollective-actionpolicy-auth) to an ldap backend.

## Installation

### Debian

For debian, first generate the debian package. Install it with `dpkg -i`. 

Install the ldap schema found in `/usr/share/doc/mcollective-ldap-action-policy/action-policy.schema`. I suggest [this tool](https://gist.github.com/jaseg/8577024) or use `puppet` to do it. There is an example with puppet in [this repository](https://github.com/nvanheuverzwijn/mcollective-ldap-authenticator/blob/master/puppet-files/manifests/default.pp#L17). 

Modify your `/etc/mcollective/server.cfg` and add those lines :

```
rpcauthorization = 1
rpcauthprovider = ldap_action_policy
```

Also add the [specific ldap-action-policy configuration](#plugin-configuration) in `/etc/mcollective/server.cfg`.

Insert your policy in your ldap server.

## Packaging

### Debian

Debian package can be generated with `make deb`. Resulting package will appear in `package/` folder.

## Development install

Install everything you need for building the development box.
```
$ make
$ cd vagrant-files
$ vagrant ssh
```

## LDAP

LDAP files are located in `ldap.schema` folder. To generate the schema, `make ldap`.

### Mcollective LDAP containers

The mcollective configuration is contained into the `treebase` plugin configuration.

The equivalent of an action policy entry is a mcollectiveRole. It consist of the following attributes.

#### mcollectiveAllow

A boolean value indicating if this entry allows (`TRUE`) the access or denies (`FALSE`) it. There can only be one of this value per entry.

#### mcollectiveCaller

A list callerID as defined by the [mcollective action policy documentation](https://github.com/puppetlabs/mcollective-actionpolicy-auth#caller-id).

#### mcollectiveAction

A list of action that a mcollective agent offers.

#### mcollectiveFact

A list of fact consisting of either `fact=value` or a [compound value](https://docs.puppet.com/mcollective/reference/basic/basic_cli_usage.html#complex-compound-or-select-queries)

#### mcollectiveClass

A list of class consiting of either `class=value` or a [compound value](https://docs.puppet.com/mcollective/reference/basic/basic_cli_usage.html#complex-compound-or-select-queries)

#### mcollectiveAgent

The mcollective agent for which this entry is applying. There can only be one of this value per entry.

#### mcollectiveHost

A list of IP address (`10.0.0.20`) or of IP mask (`10.0.0.0/8`).

#### mcollectiveOrder

The order this entry is weight. The higher the value of order is, the more weight it has. The highest order entry is chosen for the applied policy.

### Samples

A sample ldif file containing data for the mcollective schema is in `ldap.schema/action-policy-sample.ldif`. Simply calling `bin/ldap-add-action-policy-sample.sh` on the vagrant box will do the trick (look in `/mcollective-ldap-authenticator` vagrant share)

## Clean

To clean the environment, `make clean`. This delete all gem files installed via bundle and remove puppet librarian modules.

## Plugin configuration

```
plugin.ldapactionpolicy.allow_unconfigured = 1
plugin.ldapactionpolicy.treebase=ou=actionpolicy,ou=mcollective,dc=example,dc=com
plugin.ldapactionpolicy.host=127.0.0.1
plugin.ldapactionpolicy.port=389
plugin.ldapactionpolicy.username=cn=admin,dc=example,dc=com
plugin.ldapactionpolicy.password=asdF1234
```

## Tests

This project only have integration test. It can be fired using `make test`. All of those test are under the `tests` folder in the `ldap.sh` file. This file is run on the VM machine started with vagrant. It is pretty slow and needs refactor into ruby spec unit. Maybe even skip the `mco` call and use directly the ruby object for speeds.
