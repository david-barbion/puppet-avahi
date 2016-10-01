require 'spec_helper'

describe 'avahi::service' do
  let(:title) do
    'nfs'
  end

  let(:params) do
    {
      :description       => 'NFS on %h',
      :replace_wildcards => true,
      :services          => [
        {
          'type'       => '_nfs._tcp',
          'port'       => 2049,
          'txt-record' => [
            'path=/export/some/path',
          ],
        },
      ],
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without avahi class included' do
        it { expect { should compile }.to raise_error(/must include the avahi base class/) }
      end

      context 'with avahi class included', :compile do
        let(:pre_condition) do
          'include ::dbus include ::avahi'
        end

        it do
          should contain_file('/etc/avahi/services/nfs.service').with_content(<<-'EOS'.gsub(/ {12}/, ''))
            <?xml version="1.0" standalone='no'?>
            <!DOCTYPE service-group SYSTEM "avahi-service.dtd">

            <!-- !!! Managed by Puppet !!! -->

            <service-group>

              <name replace-wildcards="yes">NFS on %h</name>

              <service>
                <type>_nfs._tcp</type>
                <port>2049</port>
                <txt-record>path=/export/some/path</txt-record>
              </service>

            </service-group>
          EOS
        end
      end
    end
  end
end
