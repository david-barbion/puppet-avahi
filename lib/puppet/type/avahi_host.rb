Puppet::Type.newtype(:avahi_host) do
  desc <<-DESC
Manages an Avahi host entry.

@example Add a static host entry on behalf of an mDNS-unaware router
  include ::dbus
  include ::avahi

  avahi_host { 'router.local':
    ensure => present,
    ip     => '192.0.2.1',
  }
DESC

  @doc = 'Manages an Avahi host entry.'

  ensurable do
    defaultvalues
  end

  newparam(:name) do
    desc 'The host name.'
    isnamevar
  end

  newproperty(:ip) do
    desc 'The IP address of the host, either IPv4 or IPv6.'
  end

  newparam(:target) do
    desc 'The file in which to store the settings, defaults to `/etc/avahi/hosts`.'
    defaultto '/etc/avahi/hosts'
  end

  autorequire(:file) do
    self[:target]
  end
end
