#
class avahi (
  String                     $conf_dir                        = $::avahi::params::conf_dir,
  String                     $package_name                    = $::avahi::params::package_name,
  String                     $service_name                    = $::avahi::params::service_name,
  Optional[Boolean]          $add_service_cookie              = undef,
  Optional[Array[String, 1]] $allow_interfaces                = undef,
  Optional[Boolean]          $allow_point_to_point            = undef,
  Optional[Array[String, 1]] $browse_domains                  = [$::domain],
  Optional[Integer[0]]       $cache_entries_max               = undef,
  Optional[Boolean]          $check_response_ttl              = undef,
  Optional[Integer[0]]       $clients_max                     = undef,
  Optional[Array[String, 1]] $deny_interfaces                 = undef,
  Optional[Boolean]          $disable_publishing              = undef,
  Optional[Boolean]          $disable_user_service_publishing = undef,
  Optional[Boolean]          $disallow_other_stacks           = undef,
  Optional[String]           $domain_name                     = undef,
  Optional[Boolean]          $enable_dbus                     = undef,
  Optional[Boolean]          $enable_reflector                = undef,
  Optional[Boolean]          $enable_wide_area                = $::avahi::params::enable_wide_area,
  Optional[Integer[0]]       $entries_per_entry_group_max     = undef,
  Optional[String]           $host_name                       = undef,
  Optional[Integer[0]]       $objects_per_client_max          = undef,
  Optional[Boolean]          $publish_aaaa_on_ipv4            = undef,
  Optional[Boolean]          $publish_a_on_ipv6               = undef,
  Optional[Boolean]          $publish_addresses               = undef,
  Optional[Array[String, 1]] $publish_dns_servers             = undef,
  Optional[Boolean]          $publish_domain                  = undef,
  Optional[Boolean]          $publish_hinfo                   = undef,
  Optional[Boolean]          $publish_resolv_conf_dns_servers = undef,
  Optional[Boolean]          $publish_workstation             = undef,
  Optional[Integer[0]]       $ratelimit_burst                 = $::avahi::params::ratelimit_burst,
  Optional[Integer[0]]       $ratelimit_interval_usec         = $::avahi::params::ratelimit_interval_usec,
  Optional[Boolean]          $reflect_ipv                     = undef,
  Optional[Integer[0]]       $rlimit_as                       = undef,
  Optional[Integer[0]]       $rlimit_core                     = $::avahi::params::rlimit_core,
  Optional[Integer[0]]       $rlimit_data                     = $::avahi::params::rlimit_data,
  Optional[Integer[0]]       $rlimit_fsize                    = $::avahi::params::rlimit_fsize,
  Optional[Integer[0]]       $rlimit_nofile                   = $::avahi::params::rlimit_nofile,
  Optional[Integer[0]]       $rlimit_nproc                    = $::avahi::params::rlimit_nproc,
  Optional[Integer[0]]       $rlimit_stack                    = $::avahi::params::rlimit_stack,
  Optional[Boolean]          $use_iff_running                 = undef,
  Optional[Boolean]          $use_ipv4                        = $::avahi::params::use_ipv4,
  Optional[Boolean]          $use_ipv6                        = $::avahi::params::use_ipv6,
) inherits ::avahi::params {

  validate_absolute_path($conf_dir)
  if $browse_domains {
    validate_domain_name($browse_domains)
  }
  if $publish_dns_servers {
    validate_ip_address_array($publish_dns_servers)
  }

  contain ::avahi::install
  contain ::avahi::config
  contain ::avahi::daemon

  Class['::avahi::install'] ~> Class['::avahi::config']
    ~> Class['::avahi::daemon']
}
