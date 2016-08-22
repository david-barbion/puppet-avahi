#
class avahi::params {

  case $::osfamily {
    'RedHat': {
      $conf_dir     = '/etc/avahi'
      $package_name = 'avahi'
      $service_name = 'avahi-daemon'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.") # lint:ignore:80chars
    }
  }
}
