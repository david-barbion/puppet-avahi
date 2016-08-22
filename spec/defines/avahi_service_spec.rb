require 'spec_helper'

describe 'avahi::service' do
  let(:title) do
    'ssh'
  end

  let(:params) do
    {
      :description       => '%h',
      :replace_wildcards => true,
      :services          => [
        {
          'type' => '_ssh._tcp',
          'port' => 22,
        },
      ],
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :dbus_startup_provider => 'init',
        })
      end

      context 'without avahi class included' do
        it { expect { should compile }.to raise_error(/must include the avahi base class/) }
      end

      context 'with avahi class included', :compile do
        let(:pre_condition) do
          'include ::dbus include ::avahi'
        end

        it do
          should contain_file('/etc/avahi/services/ssh.service').with_content(<<-'EOS'.gsub(/ {12}/, ''))
            <?xml version="1.0" standalone='no'?>
            <!DOCTYPE service-group SYSTEM "avahi-service.dtd">

            <!-- !!! Managed by Puppet !!! -->

            <service-group>

              <name replace-wildcards="yes">%h</name>

              <service>
                <type>_ssh._tcp</type>
                <port>22</port>
              </service>

            </service-group>
          EOS
        end
      end
    end
  end
end
