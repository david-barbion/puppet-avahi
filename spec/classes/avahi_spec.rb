require 'spec_helper'

describe 'avahi' do
  let(:pre_condition) do
    'include dbus'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('avahi') }
      it { is_expected.to contain_class('avahi::config') }
      it { is_expected.to contain_class('avahi::daemon') }
      it { is_expected.to contain_class('avahi::install') }
      it { is_expected.to contain_dbus__system('avahi-dbus') }
      it { is_expected.to contain_file('/etc/avahi') }
      it { is_expected.to contain_file('/etc/avahi/avahi-daemon.conf') }
      it { is_expected.to contain_file('/etc/avahi/hosts') }
      it { is_expected.to contain_file('/etc/avahi/services') }
      it { is_expected.to contain_resources('avahi_host') }

      if facts[:os]['family'].eql?('OpenBSD')
        it { is_expected.to contain_group('_avahi') }
        it { is_expected.to contain_service('avahi_daemon') }
        it { is_expected.to contain_user('_avahi') }
      else
        it { is_expected.to contain_group('avahi') }
        it { is_expected.to contain_service('avahi-daemon') }
        it { is_expected.to contain_user('avahi') }
      end

      if facts[:os]['family'].eql?('Debian')
        it { is_expected.to contain_package('avahi-daemon') }
      else
        it { is_expected.to contain_package('avahi') }
      end
    end
  end
end
