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
      it { should contain_file('/etc/avahi/avahi-daemon.conf') }
      it { should contain_file('/etc/avahi/hosts') }
      it { should contain_file('/etc/avahi/services') }
      it { should contain_package('avahi') }
      it { should contain_service('avahi-daemon') }
    end
  end
end
