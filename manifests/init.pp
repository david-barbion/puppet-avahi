#
class avahi (
  $conf_dir     = $::avahi::params::conf_dir,
  $package_name = $::avahi::params::package_name,
  $service_name = $::avahi::params::service_name,
) inherits ::avahi::params {

  validate_absolute_path($conf_dir)
  validate_string($package_name)
  validate_string($service_name)

  contain ::avahi::install
  contain ::avahi::config
  contain ::avahi::daemon

  Class['::avahi::install'] ~> Class['::avahi::config']
    ~> Class['::avahi::daemon']
}
