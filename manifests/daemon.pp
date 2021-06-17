# @!visibility private
class avahi::daemon {

  service { $avahi::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
