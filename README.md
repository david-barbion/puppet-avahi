# avahi

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-avahi.svg?branch=master)](https://travis-ci.org/bodgit/puppet-avahi)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-avahi/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-avahi?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/avahi.svg)](https://forge.puppetlabs.com/bodgit/avahi)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-avahi.svg)](https://gemnasium.com/bodgit/puppet-avahi)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with avahi](#setup)
    * [What avahi affects](#what-avahi-affects)
    * [Beginning with avahi](#beginning-with-avahi)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: avahi](#class-avahi)
        * [Defined Type: avahi::service](#defined-type-avahiservice)
    * [Native Types](#native-types)
        * [Native Type: avahi_host](#native-type-avahi_host)
    * [Examples](#examples)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages Avahi for mDNS/DNS-SD services.

## Module Description

This module can install the Avahi packages, configure the D-Bus system service,
add static service definitions for advertising and manage static host name to
IP address mappings.

## Setup

If running on Puppet 3.x you will need to have the future parser enabled.

### What avahi affects

* The package(s) providing the Avahi software.
* The `avahi-daemon.conf` configuration file containing any settings.
* The service controlling the `avahi-daemon` daemon.
* D-Bus system bus configuration to make Avahi accessible over D-Bus.
* Any static service `*.service` definition files.
* Entries in the Avahi-specific `hosts` file.

### Beginning with avahi

```puppet
include ::dbus
include ::avahi
```

## Usage

### Classes and Defined Types

#### Class: `avahi`

**Parameters within `avahi`:**

##### `conf_dir`

The base configuration directory, defaults to `/etc/avahi`.

##### `package_name`

The name of the package to install that provides the Avahi software.

##### `service_name`

The name of the service managing the Avahi daemon.

##### `add_service_cookie`

Boolean controlling if a unique cookie is added to all locally registered
services.

##### `allow_interfaces`

Array of interfaces to allow mDNS traffic on.

##### `allow_point_to_point`

Boolean controlling whether to include Point-to-Point interfaces.

##### `browse_domains`

An array of additional browse domains, defaults to `[$::domain]`.

##### `cache_entries_max`

How many entries are cached per interface.

##### `check_response_ttl`

Boolean controlling whether to check the TTL of mDNS packets.

##### `clients_max`

The maximum number of D-Bus clients allowed.

##### `deny_interfaces`

Array of interfaces to explicitly deny mDNS traffic on.

##### `disable_publishing`

Boolean disabling publishing of any records.

##### `disable_user_service_publishing`

Boolean disabling publishing of records by any user applications.

##### `disallow_other_stacks`

Boolean to control if other mDNS stacks are allowed to coexist alongside
Avahi.

##### `domain_name`

Override the domain name used, normally `.local`.

##### `enable_dbus`

Boolean whether to connect to D-Bus.

##### `enable_reflector`

Boolean to enable the mDNS reflector functionality.

##### `enable_wide_area`

Boolean to enable wide-area DNS-SD.

##### `entries_per_entry_group_max`

The maximum number of entries to be registered by a single D-Bus client.

##### `host_name`

Override the host name used for the local machine.

##### `objects_per_client_max`

The maximum number of objects to be registered by a single D-Bus client.

##### `publish_aaaa_on_ipv4`

Boolean to publish an AAAA IPv6 record via IPv⒋.

##### `publish_a_on_ipv6`

Boolean to publish an A IPv4 record via IPv6.

##### `publish_addresses`

Boolean to publish mDNS address records for all local IP addresses.

##### `publish_dns_servers`

Array of unicast DNS server IP addresses to register in mDNS.

##### `publish_domain`

Boolean controlling whether to announce the local domain name for browsing by
other hosts.

##### `publish_hinfo`

Boolean controlling whether to publish an HINFO record on all interfaces.

##### `publish_resolv_conf_dns_servers`

Boolean controlling whether to publish the DNS servers listed in
`/etc/resolv.conf` in addition to any listed in `publish_dns_servers`.

##### `publish_workstation`

Boolean controlling whether to register a workstation record for the local
machine.

##### `ratelimit_burst`

Per-interface packet rate-limiting burst parameter.

##### `ratelimit_interval_usec`

Per-interface packet rate-limiting interval parameter.

##### `reflect_ipv`

Boolean controlling whether to reflect between IPv4 and IPv6.

##### `rlimit_as`

Value in bytes for `RLIMIT_AS`.

##### `rlimit_core`

Value in bytes for `RLIMIT_CORE`.

##### `rlimit_data`

Value in bytes for `RLIMIT_DATA`.

##### `rlimit_fsize`

Value for `RLIMIT_FSIZE`.

##### `rlimit_nofile`

Value for `RLIMIT_NOFILE`.

##### `rlimit_nproc`

Value for `RLIMIT_NPROC`.

##### `rlimit_stack`

Value in bytes for `RLIMIT_STACK`.

##### `use_iff_running`

Boolean controlling whether to use the `IFF_RUNNING` flag on interfaces.

##### `use_ipv4`

Boolean to disable IPv4 traffic.

##### `use_ipv6`

Boolean to disable IPv6 traffic.

#### Defined Type: `avahi::service`

**Parameters within `avahi::service`:**

##### `name`

The name of the static service. It is used to construct the filename, i.e. form
`${conf_dir}/services/${name}.service`.

##### `description`

The description of the service, any occurrence of `%h` will be replaced with
the hostname if `replace_wildcards` is set to `true`.

##### `services`

An array of service types to advertise for this service. Each element is a
hash that must contain `type` and `port` keys and can optionally contain
`protocol`, `subtype`, `domain-name`, `host-name` and `txt-record` keys. There
should be at least one element. See the `avahi.service(5)` man page for more
detail.

##### `replace_wildcards`

Boolean controlling whether any occurrence of `%h` in the service description
is replaced with the hostname.

### Native Types

#### Native Type: `avahi_host`

```puppet
Avahi_host {
  target => '/etc/avahi/hosts',
}

avahi_host { 'router.local':
  ensure => present,
  ip     => '192.0.2.1',
}
```

**Parameters within `avahi_host`:**

##### `name`

The host name.

##### `ensure`

Standard ensurable parameter.

##### `ip`

The IP address of the host.

##### `target`

The file in which to manage the host entry. Defaults to `/etc/avahi/hosts`.

If a file resource exists in the catalogue for this value it will be
autorequired.

### Examples

Install Avahi and add static service definitions for SSH and SFTP:

```puppet
include ::dbus
include ::avahi

::avahi::service { 'ssh':
  description       => '%h',
  replace_wildcards => true,
  services          => [
    {
      'type' => '_ssh._tcp',
      'port' => 22,
    },
  ],
}

::avahi::service { 'sftp-ssh':
  description       => '%h',
  replace_wildcards => true,
  services          => [
    {
      'type' => '_sftp-ssh._tcp',
      'port' => 22,
    },
  ],
}
```

Install Avahi and add a static service definition for NFS on IPv6 only:

```puppet
include ::dbus
include ::avahi

::avahi::service { 'nfs':
  description       => 'NFS on %h',
  replace_wildcards => true,
  services          => [
    {
      'type'       => '_nfs._tcp',
      'port'       => 2049,
      'protocol'   => 'ipv6',
      'txt-record' => [
        'path=/export/some/path',
      ],
    },
  ],
}
```

Install Avahi and advertise an AirPrint printer:

```puppet
include ::dbus
include ::avahi

::avahi::service { 'printer':
  description => 'An AirPrint printer',
  services    => [
    {
      'type'       => '_ipp._tcp',
      'subtype'    => [
        '_universal._sub._ipp._tcp',
      ],
      'port'       => 631,
      'txt-record' => [
        'txtver=1',
        'qtotal=1',
        'rp=printers/aPrinter',
        'ty=aPrinter',
        'adminurl=http://198.0.2.1:631/printers/aPrinter',
        'note=Office Laserjet 4100n',
        'priority=0',
        'product=(GPL Ghostscript)',
        'printer-state=3',
        'printer-type=0x801046',
        'Transparent=T',
        'Binary=T',
        'Fax=F',
        'Color=T',
        'Duplex=T',
        'Staple=F',
        'Copies=T',
        'Collate=F',
        'Punch=F',
        'Bind=F',
        'Sort=F',
        'Scan=F',
        'pdl=application/octet-stream,application/pdf,application/postscript,image/jpeg,image/png,image/urf',
        'URF=W8,SRGB24,CP1,RS600',
      ],
    },
  ],
}
```

Install Avahi and add a static host entry on behalf of an mDNS-unaware router:

```puppet
include ::dbus
include ::avahi

avahi_host { 'router.local':
  ensure => present,
  ip     => '192.0.2.1',
}
```

## Reference

### Classes

#### Public Classes

* [`avahi`](#class-avahi): Main class for managing Avahi.

#### Private Classes

* `avahi::install`: Handles Avahi installation.
* `avahi::config`: Handles Avahi configuration.
* `avahi::params`: Different configuration data for different systems.
* `avahi::daemon`: Manages the `avahi-daemon` service.

### Defined Types

#### Public Defined Types

* [`avahi::service`](#defined-type-avahiservice): Handles static service
  configuration.

### Native Types

* [`avahi_host`](#native-type-avahi_host): Manages a host entry.

## Limitations

This module has been built on and tested against Puppet 3.0 and higher.

The module has been tested on:

* RedHat/CentOS Enterprise Linux 6/7

Testing on other platforms has been light and cannot be guaranteed.

## Development

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-avahi).
