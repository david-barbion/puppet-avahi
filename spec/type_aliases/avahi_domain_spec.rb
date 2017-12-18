require 'spec_helper'

describe 'Avahi::Domain' do
  it { is_expected.to allow_values('_ssh._tcp', '_sftp-ssh._tcp') }
  it { is_expected.not_to allow_values('invalid domain', '_-hyphen._tcp') }
end
