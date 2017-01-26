#
type Avahi::Record = Struct[{'type' => Avahi::Domain, 'port' => Integer[0, 65535], Optional['protocol'] => Enum['ipv4', 'ipv6', 'any'], Optional['subtype'] => Array[Avahi::Domain], Optional['domain-name'] => String, Optional['host-name'] => Bodgitlib::Domain, Optional['txt-record'] => Array[String]}]
