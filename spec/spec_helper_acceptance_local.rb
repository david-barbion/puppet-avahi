# frozen_string_literal: true

def avahi_settings_hash
  avahi = {}

  case host_inventory['facter']['os']['family']
  when 'Debian'
    avahi['group']              = 'root'
    avahi['have_iptables']      = true
    avahi['have_service_types'] = true
    avahi['have_userspace']     = true
    avahi['package']            = 'avahi-daemon'
    avahi['service']            = 'avahi-daemon'
  when 'OpenBSD'
    avahi['group']              = 'wheel'
    avahi['have_iptables']      = false
    avahi['have_service_types'] = false
    avahi['have_userspace']     = true
    avahi['package']            = 'avahi'
    avahi['service']            = 'avahi_daemon'
  when 'RedHat'
    avahi['group']              = 'root'
    avahi['have_iptables']      = true
    avahi['have_service_types'] = true
    avahi['have_userspace']     = host_inventory['facter']['os']['release']['major'].eql?('8') ? false : true
    avahi['package']            = 'avahi'
    avahi['service']            = 'avahi-daemon'
  else
    raise 'unknown operating system'
  end

  avahi
end
