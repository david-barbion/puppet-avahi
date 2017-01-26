require 'spec_helper'

if Puppet.version.to_f >= 4.4
  describe 'test::domain', type: :class do
    describe 'accepts domains' do
      [
        '_ssh._tcp',
        '_sftp-ssh._tcp',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end
    describe 'rejects other values' do
      [
        'invalid domain',
        '_-hyphen._tcp',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
