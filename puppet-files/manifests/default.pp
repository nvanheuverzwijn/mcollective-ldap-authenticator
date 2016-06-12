class { '::openldap::server': }
::openldap::server::database { 'dc=foo,dc=example.com':
  ensure => present,
}

