require 'spec_helper'

describe Puppet::Type.type(:avahi_host) do

  it "should have :name as its keyattributes" do
    expect(described_class.key_attributes).to eq([:name])
  end

  describe 'when validating attributes' do
    [:name, :target].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end

    [:ensure, :ip].each do |property|
      it "should have a #{property} property" do
        expect(described_class.attrtype(property)).to eq(:property)
      end
    end
  end

  describe 'autorequire' do
    let(:catalog) {
      catalog = Puppet::Resource::Catalog.new
    }
    it 'should autorequire the targeted file' do
      file = Puppet::Type.type(:file).new(:name => '/etc/avahi/hosts', :content => 'test')
      catalog.add_resource file
      key = described_class.new(:name => 'router.local', :target => '/etc/avahi/hosts', :ip => '192.0.2.1', :ensure => :present)
      catalog.add_resource key
      expect(key.autorequire.size).to eq(1)
    end
  end
end
