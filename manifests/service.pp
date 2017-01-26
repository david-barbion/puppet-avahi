# Statically define a service in Avahi.
#
# @example Add static service definitions for SSH and SFTP
#   include ::dbus
#   include ::avahi
#
#   ::avahi::service { 'ssh':
#     description       => '%h',
#     replace_wildcards => true,
#     services          => [
#       {
#         'type' => '_ssh._tcp',
#         'port' => 22,
#       },
#     ],
#   }
#
#   ::avahi::service { 'sftp-ssh':
#     description       => '%h',
#     replace_wildcards => true,
#     services          => [
#       {
#         'type' => '_sftp-ssh._tcp',
#         'port' => 22,
#       },
#     ],
#   }
#
# @example Add a static service definition for NFS on IPv6 only
#   include ::dbus
#   include ::avahi
#
#   ::avahi::service { 'nfs':
#     description       => 'NFS on %h',
#     replace_wildcards => true,
#     services          => [
#       {
#         'type'       => '_nfs._tcp',
#         'port'       => 2049,
#         'protocol'   => 'ipv6',
#         'txt-record' => [
#           'path=/export/some/path',
#         ],
#       },
#     ],
#   }
#
# @example Advertise an AirPrint printer
#   include ::dbus
#   include ::avahi
#
#   ::avahi::service { 'printer':
#     description => 'An AirPrint printer',
#     services    => [
#       {
#         'type'       => '_ipp._tcp',
#         'subtype'    => [
#           '_universal._sub._ipp._tcp',
#         ],
#         'port'       => 631,
#         'txt-record' => [
#           'txtver=1',
#           'qtotal=1',
#           'rp=printers/aPrinter',
#           'ty=aPrinter',
#           'adminurl=http://198.0.2.1:631/printers/aPrinter',
#           'note=Office Laserjet 4100n',
#           'priority=0',
#           'product=(GPL Ghostscript)',
#           'printer-state=3',
#           'printer-type=0x801046',
#           'Transparent=T',
#           'Binary=T',
#           'Fax=F',
#           'Color=T',
#           'Duplex=T',
#           'Staple=F',
#           'Copies=T',
#           'Collate=F',
#           'Punch=F',
#           'Bind=F',
#           'Sort=F',
#           'Scan=F',
#           'pdl=application/octet-stream,application/pdf,application/postscript,image/jpeg,image/png,image/urf',
#           'URF=W8,SRGB24,CP1,RS600',
#         ],
#       },
#     ],
#   }
#
# @param description The description of the service, any occurence of `%h` will
#   be replaced with the hostname if `$replace_wildcards` is set to `true`.
# @param services An array of hashes which must contain `type` and `port` keys
#   and optionally `protocol`, `subtype`, `domain-name`, `host-name` and
#   `txt-record` keys.
# @param replace_wildcards Whether any occurence of `%h` is replaced with the
#   hosname.
# @param service The name of the service. It is used to construct the filename,
#   i.e. `${conf_dir}/services/${service}.service`.
#
# @see puppet_classes::avahi ::avahi
# @see https://linux.die.net/man/5/avahi.service avahi.service(5)
define avahi::service (
  String                  $description,
  Array[Avahi::Record, 1] $services,
  Optional[Boolean]       $replace_wildcards = undef,
  String                  $service           = $title,
) {

  if ! defined(Class['::avahi']) {
    fail('You must include the avahi base class before using any avahi defined resources')
  }

  $validate_cmd = $::avahi::validate ? {
    true    => "${::avahi::xmllint} --path ${::avahi::dtd_dir} --valid --noout %",
    default => undef,
  }

  file { "${::avahi::conf_dir}/services/${service}.service":
    ensure       => file,
    owner        => 0,
    group        => 0,
    mode         => '0644',
    content      => template("${module_name}/service.erb"),
    validate_cmd => $validate_cmd,
  }
}
