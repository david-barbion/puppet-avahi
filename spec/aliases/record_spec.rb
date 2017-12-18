require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'test::record', type: :class do
    describe 'accepts record structs' do
      [
        {
          'type' => '_ssh._tcp',
          'port' => 22,
        },
        {
          'type' => '_sftp-ssh._tcp',
          'port' => 22,
        },
        {
          'type'       => '_nfs._tcp',
          'port'       => 2049,
          'protocol'   => 'ipv6',
          'txt-record' => [
            'path=/export/some/path',
          ],
        },
        {
          'type'       => '_ipp._tcp',
          'subtype'    => [
            '_universal._sub._ipp._tcp',
          ],
          'port'       => 631,
          'txt-record' => [
            'txtver=1',
            'qtotal=1',
            'rp=printers/aPrinter',
            'ty=aPrinter',
            'adminurl=http://198.0.2.1:631/printers/aPrinter',
            'note=Office Laserjet 4100n',
            'priority=0',
            'product=(GPL Ghostscript)',
            'printer-state=3',
            'printer-type=0x801046',
            'Transparent=T',
            'Binary=T',
            'Fax=F',
            'Color=T',
            'Duplex=T',
            'Staple=F',
            'Copies=T',
            'Collate=F',
            'Punch=F',
            'Bind=F',
            'Sort=F',
            'Scan=F',
            'pdl=application/octet-stream,application/pdf,application/postscript,image/jpeg,image/png,image/urf',
            'URF=W8,SRGB24,CP1,RS600',
          ],
        },
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end
    describe 'rejects other values' do
      [
        {
          'invalid' => 'invalid',
        },
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
