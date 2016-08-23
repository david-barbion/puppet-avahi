#
class avahi::params {

  case $::osfamily {
    'RedHat': {
      $conf_dir                = '/etc/avahi'
      $package_name            = 'avahi'
      $service_name            = 'avahi-daemon'
      $enable_wide_area        = true
      $ratelimit_burst         = 1000
      $ratelimit_interval_usec = 1000000
      $rlimit_core             = 0
      $rlimit_data             = 4194304
      $rlimit_fsize            = 0
      $rlimit_nofile           = 768
      $rlimit_nproc            = 3
      $rlimit_stack            = 4194304
      $use_ipv4                = true
      $use_ipv6                = false
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.") # lint:ignore:80chars
    }
  }
}
