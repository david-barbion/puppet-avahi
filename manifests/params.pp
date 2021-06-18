# @!visibility private
class avahi::params {

  $conf_dir         = '/etc/avahi'
  $enable_wide_area = true
  $use_ipv4         = true

  case $facts['os']['family'] {
    'RedHat': {
      $dtd_dir             = '/usr/share/avahi'
      $package_name        = 'avahi'
      $service_name        = 'avahi-daemon'
      $group               = 'avahi'
      $policy_group        = $group
      $user                = 'avahi'
      $validate            = true
      $xmllint             = '/usr/bin/xmllint'

      case $facts['os']['release']['major'] {
        '6': {
          $browse_domains          = ['0pointer.de', 'zeroconf.org']
          $publish_hinfo           = undef
          $publish_workstation     = undef
          $ratelimit_burst         = undef
          $ratelimit_interval_usec = undef
          $rlimit_core             = 0
          $rlimit_data             = 4194304
          $rlimit_fsize            = 0
          $rlimit_nofile           = 300
          $rlimit_nproc            = 3
          $rlimit_stack            = 4194304
          $use_ipv6                = false
        }
        '7': {
          $browse_domains          = undef
          $publish_hinfo           = undef
          $publish_workstation     = undef
          $ratelimit_burst         = 1000
          $ratelimit_interval_usec = 1000000
          $rlimit_core             = 0
          $rlimit_data             = 4194304
          $rlimit_fsize            = 0
          $rlimit_nofile           = 768
          $rlimit_nproc            = 3
          $rlimit_stack            = 4194304
          $use_ipv6                = false
        }
        default: {
          $browse_domains          = undef
          $publish_hinfo           = false
          $publish_workstation     = false
          $ratelimit_burst         = 1000
          $ratelimit_interval_usec = 1000000
          $rlimit_core             = undef
          $rlimit_data             = undef
          $rlimit_fsize            = undef
          $rlimit_nofile           = undef
          $rlimit_nproc            = undef
          $rlimit_stack            = undef
          $use_ipv6                = true
        }
      }
    }
    'Debian': {
      $browse_domains          = undef
      $dtd_dir                 = '/usr/share/avahi'
      $package_name            = 'avahi-daemon'
      $service_name            = 'avahi-daemon'
      $group                   = 'avahi'
      $policy_group            = 'netdev'
      $publish_hinfo           = false
      $publish_workstation     = false
      $ratelimit_burst         = 1000
      $ratelimit_interval_usec = 1000000
      $use_ipv6                = true
      $user                    = 'avahi'
      $validate                = false # xmllint isn't naturally pulled in by dependencies
      $xmllint                 = '/usr/bin/xmllint'

      case $facts['os']['release']['major'] {
        '9': {
          $rlimit_core   = 0
          $rlimit_data   = 4194304
          $rlimit_fsize  = 0
          $rlimit_nofile = 768
          $rlimit_nproc  = 3
          $rlimit_stack  = 4194304
        }
        default: {
          $rlimit_core   = undef
          $rlimit_data   = undef
          $rlimit_fsize  = undef
          $rlimit_nofile = undef
          $rlimit_nproc  = undef
          $rlimit_stack  = undef
        }
      }
    }
    'OpenBSD': {
      $browse_domains          = undef
      $dtd_dir                 = '/usr/local/share/avahi'
      $package_name            = 'avahi'
      $service_name            = 'avahi_daemon'
      $group                   = '_avahi'
      $policy_group            = 'wheel'
      $publish_hinfo           = false
      $publish_workstation     = false
      $ratelimit_burst         = 1000
      $ratelimit_interval_usec = 1000000
      $rlimit_core             = undef
      $rlimit_data             = undef
      $rlimit_fsize            = undef
      $rlimit_nofile           = undef
      $rlimit_nproc            = undef
      $rlimit_stack            = undef
      $use_ipv6                = true
      $user                    = '_avahi'
      $validate                = true
      $xmllint                 = '/usr/local/bin/xmllint'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${facts['os']['family']} based system.")
    }
  }
}
