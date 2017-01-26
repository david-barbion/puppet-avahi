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

  it 'should work with no errors' do

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

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  # Hack to get rid of any remaining firewall rules
  describe command('iptables -F'), :unless => fact('osfamily').eql?('OpenBSD') do
    its(:exit_status) { should eq 0 }
  end

  describe package(package) do
    it { should be_installed }
  end

  describe file('/etc/avahi') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
  end

  describe file('/etc/avahi/avahi-daemon.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
  end

  describe file('/etc/avahi/hosts') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
    its(:content) { should match /^ 192\.0\.2\.1 \s+ router\.local $/x }
  end

  describe file('/etc/avahi/services') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
  end

  describe file('/etc/avahi/services/ssh.service') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
  end

  describe file('/etc/avahi/services/sftp-ssh.service') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
  end

  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('avahi-browse -a -t'), :unless => fact('osfamily').eql?('OpenBSD') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ SSH \s Remote \s Terminal \s+ local $/x }
    its(:stdout) { should match /^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ SFTP \s File \s Transfer \s+ local $/x }
  end

  # OpenBSD package seems to be lacking the compiled service types database
  describe command('avahi-browse -a -t'), :if => fact('osfamily').eql?('OpenBSD') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ _ssh\._tcp \s+ local $/x }
    its(:stdout) { should match /^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ _sftp-ssh\._tcp \s+ local $/x }
  end

  describe command('avahi-resolve -n router.local') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^ router\.local \s+ 192\.0\.2\.1 $/x }
  end
end
