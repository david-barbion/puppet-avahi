Puppet::Type.newtype(:avahi_host) do
  @doc = 'Manages an Avahi host entry.'

  ensurable do
    defaultvalues
  end

  newparam(:name) do
    desc 'The host name.'
    isnamevar
  end

  newproperty(:ip) do
    desc "The host's IP address, IPv4 or IPv6."
  end

  newparam(:target) do
    desc 'The file in which to store the settings, defaults to `/etc/avahi/hosts`.'
    defaultto '/etc/avahi/hosts'
  end

  autorequire(:file) do
    self[:target]
  end
end
