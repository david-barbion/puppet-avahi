require 'spec_helper_acceptance'

describe 'avahi' do

  it 'should work with no errors' do

    pp = <<-EOS
      include ::firewall
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

      package { 'avahi-tools':
        ensure => present,
      }
    EOS

    apply_manifest(pp, :catch_failures => true, :future_parser => true)
    apply_manifest(pp, :catch_changes  => true, :future_parser => true)
  end

  describe package('avahi') do
    it { should be_installed }
  end

  describe file('/etc/avahi') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/avahi/avahi-daemon.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/avahi/hosts') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/avahi/services') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/avahi/services/ssh.service') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/avahi/services/sftp-ssh.service') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe service('avahi-daemon') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('avahi-browse -a -t') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ SSH \s Remote \s Terminal \s+ local $/x }
    its(:stdout) { should match /^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ SFTP \s File \s Transfer \s+ local $/x }
    its(:stdout) { should match /^ \+ \s+ \S+ \s+ IPv4 \s+ #{fact('hostname')} \s+ \[ [0-9a-f]{2} (?::[0-9a-f]{2}){5} \] \s+ Workstation \s+ local $/x }
  end
end
