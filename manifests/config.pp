#
class avahi::config {

  $conf_dir = $::avahi::conf_dir

  file { $conf_dir:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  # FIXME concat, augeas, etc.
  file { "${conf_dir}/hosts":
    ensure => file,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  file { "${conf_dir}/services":
    ensure       => directory,
    owner        => 0,
    group        => 0,
    mode         => '0644',
    force        => true,
    purge        => true,
    recurse      => true,
    recurselimit => 1,
  }

  file { "${conf_dir}/avahi-daemon.conf":
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template('avahi/avahi-daemon.conf.erb'),
  }

  ::dbus::system { 'avahi-dbus':
    content => file('avahi/avahi-dbus.conf'),
  }
}
