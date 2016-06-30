require 'net/ldap'

ldap = Net::LDAP.new :host => '10.0.0.2',
  :port => 389,
  :auth => {
        :method => :simple,
        :username => "cn=admin,dc=example,dc=com",
        :password => "asdF1234"
  }

filter = Net::LDAP::Filter.eq( "cn", "*" )
treebase = "ou=actionpolicy,ou=mcollective,dc=example,dc=com"

ldap.search( :base => treebase, :filter => filter, :return_result => false ) do |entry|
  puts entry.inspect
end

