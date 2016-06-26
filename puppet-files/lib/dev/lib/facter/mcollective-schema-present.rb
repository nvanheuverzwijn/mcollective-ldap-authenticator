Facter.add(:mcollective_schema_present) do
  setcode do
    if File.exist? '/mcollective-ldap-authenticator/ldap.schema/mcollective.schema'
      'true'
    else
      'false'
    end
  end
end
