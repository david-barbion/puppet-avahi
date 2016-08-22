#
define avahi::service (
  String            $description,
  Array[
    Struct[
      {
        'type'                  => String,
        'port'                  => Integer[0, 65535],
        Optional['protocol']    => Enum['ipv4', 'ipv6', 'any'],
        Optional['subtype']     => Array[String],
        Optional['domain-name'] => String,
        Optional['host-name']   => String,
        Optional['txt-record']  => Array[String],
      }
    ],
    1
  ]                 $services,
  Optional[Boolean] $replace_wildcards = undef,
) {

  if ! defined(Class['::avahi']) {
    fail('You must include the avahi base class before using any avahi defined resources')
  }

  file { "${::avahi::conf_dir}/services/${name}.service":
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template('avahi/service.erb'),
  }
}
