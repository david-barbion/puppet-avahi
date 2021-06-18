require 'spec_helper_acceptance'

avahi_hash = avahi_settings_hash

describe 'avahi' do
  let(:pp) do
    <<-MANIFEST
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

      avahi_host { 'router.local':
        ip => '192.0.2.1',
      }

      case $facts['os']['family'] {
        'RedHat': {
          # EL8 is missing this package
          if $facts['os']['release']['major'] != '8' {
            package { 'avahi-tools':
              ensure => present,
            }
          }
        }
        'Debian': {
          package { 'avahi-utils':
            ensure => present,
          }
        }
      }
    MANIFEST
  end

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  # Get rid of any firewall rules
  ['filter', 'nat', 'mangle'].each do |table|
    describe command("iptables -t #{table} -F"), if: avahi_hash['have_iptables'] do
      its(:exit_status) { is_expected.to eq 0 }
    end

    describe command("iptables -t #{table} -X"), if: avahi_hash['have_iptables'] do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  describe package(avahi_hash['package']) do
    it { is_expected.to be_installed }
  end

  describe file('/etc/avahi') do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into avahi_hash['group'] }
  end

  describe file('/etc/avahi/avahi-daemon.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into avahi_hash['group'] }
  end

  describe file('/etc/avahi/hosts') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into avahi_hash['group'] }
    its(:content) { is_expected.to match(%r{^ 192\.0\.2\.1 \s+ router\.local $}x) }
  end

  describe file('/etc/avahi/services') do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into avahi_hash['group'] }
  end

  describe file('/etc/avahi/services/ssh.service') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into avahi_hash['group'] }
  end

  describe file('/etc/avahi/services/sftp-ssh.service') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into avahi_hash['group'] }
  end

  describe service(avahi_hash['service']) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe command('avahi-browse -a -t'), if: avahi_hash['have_userspace'] && avahi_hash['have_service_types'] do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) do
      is_expected.to match(%r{^ \+ \s+ \S+ \s+ IPv4 \s+ #{host_inventory['facter']['networking']['hostname']} \s+ SSH \s Remote \s Terminal \s+ local $}x)
      is_expected.to match(%r{^ \+ \s+ \S+ \s+ IPv4 \s+ #{host_inventory['facter']['networking']['hostname']} \s+ SFTP \s File \s Transfer \s+ local $}x)
    end
  end

  # OpenBSD package seems to be lacking the compiled service types database
  describe command('avahi-browse -a -t'), if: avahi_hash['have_userspace'] && !avahi_hash['have_service_types'] do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) do
      is_expected.to match(%r{^ \+ \s+ \S+ \s+ IPv4 \s+ #{host_inventory['facter']['networking']['hostname']} \s+ _ssh\._tcp \s+ local $}x)
      is_expected.to match(%r{^ \+ \s+ \S+ \s+ IPv4 \s+ #{host_inventory['facter']['networking']['hostname']} \s+ _sftp-ssh\._tcp \s+ local $}x)
    end
  end

  describe command('avahi-resolve -n router.local'), if: avahi_hash['have_userspace'] do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match(%r{^ router\.local \s+ 192\.0\.2\.1 $}x) }
  end
end
