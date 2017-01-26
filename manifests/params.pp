# @!visibility private
class avahi::params {

  $conf_dir         = '/etc/avahi'
  $enable_wide_area = true
  $rlimit_core      = 0
  $rlimit_data      = 4194304
  $rlimit_fsize     = 0
  $rlimit_nofile    = 768
  $rlimit_nproc     = 3
  $rlimit_stack     = 4194304
  $use_ipv4         = true

  case $::osfamily {
    'RedHat': {
      $dtd_dir             = '/usr/share/avahi'
      $package_name        = 'avahi'
      $service_name        = 'avahi-daemon'
      $group               = 'avahi'
      $policy_group        = $group
      $publish_hinfo       = undef
      $publish_workstation = undef
      $use_ipv6            = false
      $user                = 'avahi'
      $validate            = true
      $xmllint             = '/usr/bin/xmllint'

      case $::operatingsystemmajrelease {
        '6': {
          $ratelimit_burst         = undef
          $ratelimit_interval_usec = undef
        }
        default: {
          $ratelimit_burst         = 1000
          $ratelimit_interval_usec = 1000000
        }
      }
    }
    'Debian': {
      $dtd_dir                 = '/usr/share/avahi'
      $package_name            = 'avahi-daemon'
      $service_name            = 'avahi-daemon'
      $group                   = 'avahi'
      $policy_group            = 'netdev'
      $ratelimit_burst         = 1000
      $ratelimit_interval_usec = 1000000
      $use_ipv6                = true
      $user                    = 'avahi'
      $validate                = false # xmllint isn't naturally pulled in by dependencies
      $xmllint                 = '/usr/bin/xmllint'

      case $::operatingsystem {
        'Ubuntu': {
          case $::operatingsystemrelease {
            '14.04': {
              $publish_hinfo       = undef
              $publish_workstation = undef
            }
            default: {
              $publish_hinfo       = false
              $publish_workstation = false
            }
          }
        }
        default: {
          $publish_hinfo       = undef
          $publish_workstation = undef
        }
      }
    }
    'OpenBSD': {
      $dtd_dir                 = '/usr/local/share/avahi'
      $package_name            = 'avahi'
      $service_name            = 'avahi_daemon'
      $group                   = '_avahi'
      $policy_group            = 'wheel'
      $publish_hinfo           = false
      $publish_workstation     = false
      $ratelimit_burst         = 1000
      $ratelimit_interval_usec = 1000000
      $use_ipv6                = false
      $user                    = '_avahi'
      $validate                = true
      $xmllint                 = '/usr/local/bin/xmllint'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
