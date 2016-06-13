#
# globals
#
$all_password = '74yr6!$hf4iur'

#
# openldap
#
class { '::openldap::server': }
::openldap::server::database { 'dc=foo,dc=example.com':
  ensure => present,
}

# rabbitmq
file { '/etc/ssl/certs/ca.crt':
  source => 'puppet:///modules/dev/ssl/ca.crt',
}
->
file { '/etc/rabbitmq/ssl/middleware.crt':
  source => 'puppet:///modules/dev/ssl/middleware.crt',
}
->
file { '/etc/rabbitmq/ssl/middleware.key':
  source => 'puppet:///modules/dev/ssl/middleware.key',
  owner => 'rabbitmq',
}



#
# rabbitmq
#
class { '::rabbitmq':
  config_stomp => true,
  management_ssl => false,
  ssl_stomp_port => 61614,
  stomp_port => 61613,
}

rabbitmq_plugin {'rabbitmq_stomp':
  ensure => present,
  notify => Service['rabbitmq-server'],
}

rabbitmq_vhost { '/mcollective': 
  ensure => present,
  notify => Service['rabbitmq-server'],
}

rabbitmq_user { 'admin':
  ensure   => present,
  admin    => true,
  password => $all_password,
  notify   => Service['rabbitmq-server'],
}

rabbitmq_user_permissions { "admin@/mcollective":
  configure_permission => '.*',
  read_permission      => '.*',
  write_permission     => '.*',
  notify               => Service['rabbitmq-server'],
}

rabbitmq_exchange { "mcollective_broadcast@/mcollective":
  ensure      => present,
  type        => 'topic',
  user        => 'admin',
  password    => $all_password,
  auto_delete => false,
  durable     => true,
  internal    => false,
}

rabbitmq_exchange { "mcollective_directed@/mcollective":
  ensure      => present,
  type        => 'direct',
  user        => 'admin',
  password    => $all_password,
  auto_delete => false,
  durable     => true,
  internal    => false,
}

rabbitmq_exchange { "mcollective_reply@/mcollective":
  ensure      => present,
  type        => 'direct',
  user        => 'admin',
  password    => $all_password,
  auto_delete => false,
  durable     => true,
  internal    => false,
}




#
#mcollective
#
file { '/etc/mcollective/ssl/clients/root.crt':
  source => 'puppet:///modules/dev/ssl/client.crt',
  require => Class['mcollective'],
}

class { '::mcollective': 
  client => true,
  connector => 'rabbitmq',
  middleware_hosts => ['localhost'],
  middleware_user => 'admin',
  middleware_password           => $all_password,
  middleware_admin_user         => 'admin',
  middleware_admin_password     => $all_password,
  securityprovider    => 'ssl',
  ssl_ca_cert         => 'puppet:///modules/dev/ssl/ca.crt',
  ssl_server_public   => 'puppet:///modules/dev/ssl/server.crt',
  ssl_server_private  => 'puppet:///modules/dev/ssl/server.key',
  core_libdir => '/usr/share/mcollective/plugins',
  require => Class['rabbitmq'],
}

mcollective::user { 'root':
  homedir     => '/root',
  group       => 'users',
  require     => Class['::mcollective'],
  certificate => 'puppet:///modules/dev/ssl/client.crt',
  private_key => 'puppet:///modules/dev/ssl/client.key',
}

::mcollective::user::setting { "root plugin.rabbitmq.pool.1.user":
  username => 'root',
  setting  => 'plugin.rabbitmq.pool.1.user',
  value    => 'admin',
  require  => Class['::mcollective'],
}

::mcollective::user::setting { "root plugin.rabbitmq.pool.1.password":
  username => 'root',
  setting  => 'plugin.rabbitmq.pool.1.password',
  value    => $all_password,
  require  => Class['::mcollective'],
}

::mcollective::user::setting { "root plugin.rabbitmq.use_reply_exchange":
  username => 'root',
  setting  => 'plugin.rabbitmq.use_reply_exchange',
  value    => true,
  require  => Class['::mcollective'],
}
