# avahi

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-avahi.svg?branch=master)](https://travis-ci.org/bodgit/puppet-avahi)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-avahi/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-avahi?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/avahi.svg)](https://forge.puppetlabs.com/bodgit/avahi)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-avahi.svg)](https://gemnasium.com/bodgit/puppet-avahi)

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

RHEL/CentOS, Ubuntu, Debian and OpenBSD are supported using Puppet 4.4.0 or
later.

## Setup

### Beginning with avahi

In the very simplest case, you can just include the following:

```puppet
include ::dbus
include ::avahi
```

## Usage

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

The reference documentation is generated with
[puppet-strings](https://github.com/puppetlabs/puppet-strings) and the latest
version of the documentation is hosted at
[https://bodgit.github.io/puppet-avahi/](https://bodgit.github.io/puppet-avahi/).

## Limitations

This module has been built on and tested against Puppet 4.4.0 and higher.

The module has been tested on:

* RedHat Enterprise Linux 6/7
* Ubuntu 14.04/16.04
* Debian 7/8
* OpenBSD 6.0

## Development

The module has both [rspec-puppet](http://rspec-puppet.com) and
[beaker-rspec](https://github.com/puppetlabs/beaker-rspec) tests. Run them
with:

```
$ bundle exec rake test
$ PUPPET_INSTALL_TYPE=agent PUPPET_INSTALL_VERSION=x.y.z bundle exec rake beaker:<nodeset>
```

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-avahi).
