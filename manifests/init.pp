# Installs and configures Avahi.
#
# @example Declaring the class
#   include dbus
#   include avahi
#
# @param conf_dir The top-level configuration directory, usually `/etc/avahi`.
# @param dtd_dir The directory containing the XML DTD for service validation.
# @param group The unprivileged group used to run the daemon.
# @param package_name The name of the package.
# @param policy_group The group that is allowed by policy to set the mDNS
#   hostname.
# @param service_name The service name.
# @param user The unprivileged user used to run the daemon.
# @param validate Whether to try and validate service files prior to installing
#   them.
# @param xmllint The path to the xmllint binary used to validate service files.
# @param add_service_cookie Whether a unique cookie is added to all locally
#   registered services.
# @param allow_interfaces Interfaces to allow mDNS traffic on.
# @param allow_point_to_point Include Point-to-Point interfaces.
# @param browse_domains Additional browse domains.
# @param cache_entries_max How many entries are cached per interface.
# @param check_response_ttl Whether to check the TTL of mDNS packets.
# @param clients_max Maximum number of D-Bus clients permitted.
# @param deny_interfaces Interfaces to explicitly deny mDNS traffic on.
# @param disable_publishing Disable publishing of any records.
# @param disable_user_service_publishing Disable publishing of records by user
#   applications.
# @param disallow_other_stacks Whether to allow other mDNS stacks to run on the
#   host.
# @param domain_name Override the domain name used, `.local` normally.
# @param enable_dbus Whether to connect to D-Bus.
# @param enable_reflector Whether to enable the mDNS reflector.
# @param enable_wide_area Enable wide-area mDNS.
# @param entries_per_entry_group_max The maximum number of entries to be
#   registered by a single D-Bus client.
# @param host_name Override the hostname used for the local machine.
# @param objects_per_client_max The maximum number of objects to be registered
#   by a single D-Bus client.
# @param publish_aaaa_on_ipv4 Whether to publish AAAA records via IPv4.
# @param publish_a_on_ipv6 Whether to publish A records via IPv6.
# @param publish_addresses Whether to publish mDNS address records for all
#   local IP addresses.
# @param publish_dns_servers List of unicast DNS servers to publish in mDNS.
# @param publish_domain Whether to announce the local domain name for browsing
#   by other hosts.
# @param publish_hinfo Whether to publish `HINFO` records on all interfaces.
# @param publish_resolv_conf_dns_servers Whether to publish the DNS servers
#   listed in `/etc/resolv.conf` in addition to any listed in
#   `publish_dns_servers`.
# @param publish_workstation Whether to publish a workstation record for the
#   local machine.
# @param ratelimit_burst Per-interface packet rate-limiting burst parameter.
# @param ratelimit_interval_usec Per-interface packet rate-limiting interval
#   parameter.
# @param reflect_ipv Whether to reflect between IPv4 and IPv6.
# @param rlimit_as Value in bytes for `RLIMIT_AS`.
# @param rlimit_core Value in bytes for `RLIMIT_CORE`.
# @param rlimit_data Value in bytes for `RLIMIT_DATA`.
# @param rlimit_fsize Value for `RLIMIT_FSIZE`.
# @param rlimit_nofile Value for `RLIMIT_NOFILE`.
# @param rlimit_nproc
# @param rlimit_stack
# @param use_iff_running
# @param use_ipv4
# @param use_ipv6
#
# @see puppet_defined_types::avahi::service avahi::service
class avahi (
  Stdlib::Absolutepath                      $conf_dir                        = $avahi::params::conf_dir,
  Stdlib::Absolutepath                      $dtd_dir                         = $avahi::params::dtd_dir,
  String                                    $group                           = $avahi::params::group,
  String                                    $package_name                    = $avahi::params::package_name,
  String                                    $policy_group                    = $avahi::params::policy_group,
  String                                    $service_name                    = $avahi::params::service_name,
  String                                    $user                            = $avahi::params::user,
  Boolean                                   $validate                        = $avahi::params::validate,
  Stdlib::Absolutepath                      $xmllint                         = $avahi::params::xmllint,
  Optional[Boolean]                         $add_service_cookie              = undef,
  Optional[Array[String, 1]]                $allow_interfaces                = undef,
  Optional[Boolean]                         $allow_point_to_point            = undef,
  Optional[Array[Bodgitlib::Domain, 1]]     $browse_domains                  = undef,
  Optional[Integer[0]]                      $cache_entries_max               = undef,
  Optional[Boolean]                         $check_response_ttl              = undef,
  Optional[Integer[0]]                      $clients_max                     = undef,
  Optional[Array[String, 1]]                $deny_interfaces                 = undef,
  Optional[Boolean]                         $disable_publishing              = undef,
  Optional[Boolean]                         $disable_user_service_publishing = undef,
  Optional[Boolean]                         $disallow_other_stacks           = undef,
  Optional[String]                          $domain_name                     = undef,
  Optional[Boolean]                         $enable_dbus                     = undef,
  Optional[Boolean]                         $enable_reflector                = undef,
  Optional[Boolean]                         $enable_wide_area                = $avahi::params::enable_wide_area,
  Optional[Integer[0]]                      $entries_per_entry_group_max     = undef,
  Optional[String]                          $host_name                       = undef,
  Optional[Integer[0]]                      $objects_per_client_max          = undef,
  Optional[Boolean]                         $publish_aaaa_on_ipv4            = undef,
  Optional[Boolean]                         $publish_a_on_ipv6               = undef,
  Optional[Boolean]                         $publish_addresses               = undef,
  Optional[Array[IP::Address::NoSubnet, 1]] $publish_dns_servers             = undef,
  Optional[Boolean]                         $publish_domain                  = undef,
  Optional[Boolean]                         $publish_hinfo                   = $avahi::params::publish_hinfo,
  Optional[Boolean]                         $publish_resolv_conf_dns_servers = undef,
  Optional[Boolean]                         $publish_workstation             = $avahi::params::publish_workstation,
  Optional[Integer[0]]                      $ratelimit_burst                 = $avahi::params::ratelimit_burst,
  Optional[Integer[0]]                      $ratelimit_interval_usec         = $avahi::params::ratelimit_interval_usec,
  Optional[Boolean]                         $reflect_ipv                     = undef,
  Optional[Integer[0]]                      $rlimit_as                       = undef,
  Optional[Integer[0]]                      $rlimit_core                     = $avahi::params::rlimit_core,
  Optional[Integer[0]]                      $rlimit_data                     = $avahi::params::rlimit_data,
  Optional[Integer[0]]                      $rlimit_fsize                    = $avahi::params::rlimit_fsize,
  Optional[Integer[0]]                      $rlimit_nofile                   = $avahi::params::rlimit_nofile,
  Optional[Integer[2]]                      $rlimit_nproc                    = $avahi::params::rlimit_nproc,
  Optional[Integer[0]]                      $rlimit_stack                    = $avahi::params::rlimit_stack,
  Optional[Boolean]                         $use_iff_running                 = undef,
  Optional[Boolean]                         $use_ipv4                        = $avahi::params::use_ipv4,
  Optional[Boolean]                         $use_ipv6                        = $avahi::params::use_ipv6,
) inherits avahi::params {

  contain avahi::install
  contain avahi::config
  contain avahi::daemon

  Class['avahi::install'] ~> Class['avahi::config'] ~> Class['avahi::daemon']
}
