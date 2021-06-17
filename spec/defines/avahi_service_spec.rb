require 'spec_helper'

describe 'avahi::service' do
  let(:pre_condition) do
    'include dbus'
  end

  let(:title) do
    'nfs'
  end

  let(:params) do
    {
      description:       'NFS on %h',
      replace_wildcards: true,
      services:          [
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

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_file('/etc/avahi/services/nfs.service').with_content(<<-'EOS'.gsub(%r{ {10}}, ''))
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
