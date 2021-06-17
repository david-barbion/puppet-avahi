require 'spec_helper'

describe 'Avahi::Record' do
  it {
    is_expected.to allow_value({
                                 'type' => '_ssh._tcp',
                                 'port' => 22,
                               })
  }
  it {
    is_expected.to allow_value({
                                 'type' => '_sftp-ssh._tcp',
                                 'port' => 22,
                               })
  }
  it {
    is_expected.to allow_value({
                                 'type'       => '_nfs._tcp',
                                 'port'       => 2049,
                                 'protocol'   => 'ipv6',
                                 'txt-record' => [
                                   'path=/export/some/path',
                                 ],
                               })
  }
  it {
    is_expected.to allow_value({
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
                               })
  }
  it { is_expected.not_to allow_value({ 'invalid' => 'invalid' }) }
end
