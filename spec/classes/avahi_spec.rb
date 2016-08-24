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

    it { expect { should compile }.to raise_error(/not supported on an Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts.merge({
          :dbus_startup_provider => 'init',
        })
      end

      it { should contain_class('avahi') }
      it { should contain_class('avahi::config') }
      it { should contain_class('avahi::daemon') }
      it { should contain_class('avahi::install') }
      it { should contain_class('avahi::params') }
      it { should contain_dbus__system('avahi-dbus') }
      it { should contain_file('/etc/avahi') }
      it { should contain_file('/etc/avahi/hosts') }
      it { should contain_file('/etc/avahi/services') }
      it { should contain_package('avahi') }
      it { should contain_service('avahi-daemon') }

      case facts[:osfamily]
      when 'RedHat'
        case facts[:operatingsystemmajrelease]
        when '6'
          it do
            should contain_file('/etc/avahi/avahi-daemon.conf').with_content(<<-EOS.gsub(/ {12}/, ''))
            # !!! Managed by Puppet !!!

            [server]
            browse-domains=#{facts[:domain]}
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
          end
        else
          it do
            should contain_file('/etc/avahi/avahi-daemon.conf').with_content(<<-EOS.gsub(/ {12}/, ''))
            # !!! Managed by Puppet !!!

            [server]
            browse-domains=#{facts[:domain]}
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
          end
        end
      end
    end
  end
end
