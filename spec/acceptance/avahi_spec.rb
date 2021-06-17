require 'spec_helper_acceptance'

describe 'avahi' do
  case fact('osfamily')
  when 'RedHat'
    group   = 'root'
    package = 'avahi'
    service = 'avahi-daemon'
  when 'Debian'
    group   = 'root'
    package = 'avahi-daemon'
    service = 'avahi-daemon'
  when 'OpenBSD'
    group   = 'wheel'
    package = 'avahi'
    service = 'avahi_daemon'
  end

  it 'works with no errors' do
    pp = <<-EOS
      Package {
        source => $::osfamily ? {
          # $::architecture fact has gone missing on facter 3.x package currently installed
          'OpenBSD' => "http://ftp.openbsd.org/pub/OpenBSD/${::operatingsystemrelease}/packages/amd64/",
          default   => undef,
        },
      }

      if $::osfamily != 'OpenBSD' {
        include ::firewall
      }

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

      avahi_host { 'router.local':
        ip => '192.0.2.1',
      }

      case $::osfamily {
        'RedHat': {
          package { 'avahi-tools':
            ensure => present,
          }
        }
        'Debian': {
          package { 'avahi-utils':
            ensure => present,
          }
        }
      }
    EOS

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  # Hack to get rid of any remaining firewall rules
  describe command('iptables -F'), unless: fact('osfamily').eql?('OpenBSD') do
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe package(package) do
    it { is_expected.to be_installed }
  end

  describe file('/etc/avahi') do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
  end

  describe file('/etc/avahi/avahi-daemon.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
  end

  describe file('/etc/avahi/hosts') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
    its(:content) { is_expected.to match(%r{^ 192\.0\.2\.1 \s+ router\.local $}x) }
  end

  describe file('/etc/avahi/services') do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 755 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
  end

  describe file('/etc/avahi/services/ssh.service') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
  end

  describe file('/etc/avahi/services/sftp-ssh.service') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into group }
  end

  describe service(service) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe command('avahi-browse -a -t'), unless: fact('osfamily').eql?('OpenBSD') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) do
      is_expected.to match(%r{^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ SSH \s Remote \s Terminal \s+ local $}x)
      is_expected.to match(%r{^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ SFTP \s File \s Transfer \s+ local $}x)
    end
  end

  # OpenBSD package seems to be lacking the compiled service types database
  describe command('avahi-browse -a -t'), if: fact('osfamily').eql?('OpenBSD') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) do
      is_expected.to match(%r{^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ _ssh\._tcp \s+ local $}x)
      is_expected.to match(%r{^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ _sftp-ssh\._tcp \s+ local $}x)
    end
  end

  describe command('avahi-resolve -n router.local') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match(%r{^ router\.local \s+ 192\.0\.2\.1 $}x) }
  end
end
