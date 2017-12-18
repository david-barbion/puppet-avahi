require 'spec_helper'

describe 'avahi' do

  let(:pre_condition) do
    'include ::dbus'
  end

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { is_expected.to compile.and_raise_error(/not supported on an Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts
      end

      it { is_expected.to contain_class('avahi') }
      it { is_expected.to contain_class('avahi::config') }
      it { is_expected.to contain_class('avahi::daemon') }
      it { is_expected.to contain_class('avahi::install') }
      it { is_expected.to contain_class('avahi::params') }
      it { is_expected.to contain_dbus__system('avahi-dbus') }
      it { is_expected.to contain_file('/etc/avahi') }
      it { is_expected.to contain_file('/etc/avahi/hosts') }
      it { is_expected.to contain_file('/etc/avahi/services') }
      it { is_expected.to contain_resources('avahi_host') }

      case facts[:osfamily]
      when 'RedHat'
        it { is_expected.to contain_group('avahi') }
        it { is_expected.to contain_package('avahi') }
        it { is_expected.to contain_service('avahi-daemon') }
        it { is_expected.to contain_user('avahi') }

        case facts[:operatingsystemmajrelease]
        when '6'
          it {
            is_expected.to contain_file('/etc/avahi/avahi-daemon.conf').with_content(<<-EOS.gsub(/ {12}/, ''))
            # !!! Managed by Puppet !!!

            [server]
            use-ipv4=yes
            use-ipv6=no

            [wide-area]
            enable-wide-area=yes

            [publish]

            [reflector]

            [rlimits]
            rlimit-core=0
            rlimit-data=4194304
            rlimit-fsize=0
            rlimit-nofile=768
            rlimit-stack=4194304
            rlimit-nproc=3
            EOS
          }
        else
          it {
            is_expected.to contain_file('/etc/avahi/avahi-daemon.conf').with_content(<<-EOS.gsub(/ {12}/, ''))
            # !!! Managed by Puppet !!!

            [server]
            use-ipv4=yes
            use-ipv6=no
            ratelimit-interval-usec=1000000
            ratelimit-burst=1000

            [wide-area]
            enable-wide-area=yes

            [publish]

            [reflector]

            [rlimits]
            rlimit-core=0
            rlimit-data=4194304
            rlimit-fsize=0
            rlimit-nofile=768
            rlimit-stack=4194304
            rlimit-nproc=3
            EOS
          }
        end
      when 'Debian'
        it { is_expected.to contain_group('avahi') }
        it { is_expected.to contain_package('avahi-daemon') }
        it { is_expected.to contain_service('avahi-daemon') }
        it { is_expected.to contain_user('avahi') }
      when 'OpenBSD'
        it { is_expected.to contain_group('_avahi') }
        it { is_expected.to contain_package('avahi') }
        it { is_expected.to contain_service('avahi_daemon') }
        it { is_expected.to contain_user('_avahi') }
      end
    end
  end
end
