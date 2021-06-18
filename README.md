# avahi

[![Build Status](https://img.shields.io/github/workflow/status/bodgit/puppet-avahi/Test)](https://github.com/bodgit/puppet-avahi/actions?query=workflow%3ATest)
[![Codecov](https://img.shields.io/codecov/c/github/bodgit/puppet-avahi)](https://codecov.io/gh/bodgit/puppet-avahi)
[![Puppet Forge version](http://img.shields.io/puppetforge/v/bodgit/avahi)](https://forge.puppetlabs.com/bodgit/avahi)
[![Puppet Forge downloads](https://img.shields.io/puppetforge/dt/bodgit/avahi)](https://forge.puppetlabs.com/bodgit/avahi)
[![Puppet Forge - PDK version](https://img.shields.io/puppetforge/pdk-version/bodgit/avahi)](https://forge.puppetlabs.com/bodgit/avahi)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with avahi](#setup)
    * [Beginning with avahi](#beginning-with-avahi)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module manages Avahi for mDNS/DNS-SD services.

RHEL/CentOS, Ubuntu, Debian and OpenBSD are supported using Puppet 5 or
later.

## Setup

### Beginning with avahi

In the very simplest case, you can just include the following:

```puppet
include dbus
include avahi
```

## Usage

Install Avahi and add static service definitions for SSH and SFTP:

```puppet
include dbus
include avahi

avahi::service { 'ssh':
  description       => '%h',
  replace_wildcards => true,
  services          => [
    {
      'type' => '_ssh._tcp',
      'port' => 22,
    },
  ],
}

avahi::service { 'sftp-ssh':
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

Install Avahi and add a static host entry on behalf of an mDNS-unaware router:

```puppet
include dbus
include avahi

avahi_host { 'router.local':
  ensure => present,
  ip     => '192.0.2.1',
}
```

## Reference

The reference documentation is generated with
[puppet-strings](https://github.com/puppetlabs/puppet-strings) and the latest
version of the documentation is hosted at
[https://bodgit.github.io/puppet-avahi/](https://bodgit.github.io/puppet-avahi/)
and available also in the [REFERENCE.md](https://github.com/bodgit/puppet-avahi/blob/main/REFERENCE.md).

## Limitations

This module has been built on and tested against Puppet 5 and higher.

The module has been tested on:

* Red Hat/CentOS Enterprise Linux 6/7/8
* Ubuntu 16.04/18.04/20.04
* Debian 9/10
* OpenBSD 6.9

## Development

The module relies on [PDK](https://puppet.com/docs/pdk/1.x/pdk.html) and has
both [rspec-puppet](http://rspec-puppet.com) and
[Litmus](https://github.com/puppetlabs/puppet_litmus) tests. Run them
with:

```
$ bundle exec rake spec
$ bundle exec rake litmus:*
```

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-avahi).
