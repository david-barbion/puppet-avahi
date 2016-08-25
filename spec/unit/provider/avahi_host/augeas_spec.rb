require 'spec_helper'
require 'fileutils'

provider_class = Puppet::Type.type(:avahi_host).provider(:augeas)

describe provider_class do

  let(:tmpdir) { Dir.mktmpdir('statetmp').encode!(Encoding::UTF_8) }

  before :each do
    Puppet::Type.type(:avahi_host).stubs(:defaultprovider).returns described_class
    FileTest.stubs(:exist?).returns false
    FileTest.stubs(:exist?).with('/etc/avahi/hosts').returns true
    Puppet[:statedir] = tmpdir
  end

  after :each do
    FileUtils.rm_rf(tmpdir)
  end

  context 'with empty file' do
    let(:tmptarget) { aug_fixture('empty') }
    let(:target) { tmptarget.path }

    it 'should create simple new entry' do
      apply!(Puppet::Type.type(:avahi_host).new(
        :name     => 'router.local',
        :ip       => '192.0.2.1',
        :target   => target,
        :provider => 'augeas',
      ))

      aug_open(target, 'Hosts.lns') do |aug|
        expect(aug.get("*[canonical = 'router.local']/ipaddr")).to eq('192.0.2.1')
      end
    end
  end

  context 'with full file' do
    let(:tmptarget) { aug_fixture('full') }
    let(:target) { tmptarget.path }

    it 'should list instances' do
      provider_class.stubs(:target).returns(target)
      inst = provider_class.instances.map { |p|
        {
          :name   => p.get(:name),
          :ensure => p.get(:ensure),
          :ip     => p.get(:ip),
        }
      }

      expect(inst.size).to eq(1)
      expect(inst[0]).to eq({:name => 'router.local', :ensure => :present, :ip => '192.0.2.1'})
    end

    describe 'when deleting settings' do
      it 'should delete a setting' do
        expr = "*[canonical = 'router.local']"
        aug_open(target, 'Hosts.lns') do |aug|
          expect(aug.match(expr)).not_to eq([])
        end

        apply!(Puppet::Type.type(:avahi_host).new(
          :name     => 'router.local',
          :ensure   => 'absent',
          :target   => target,
          :provider => 'augeas',
        ))

        aug_open(target, 'Hosts.lns') do |aug|
          expect(aug.match(expr)).to eq([])
        end
      end
    end
  end
end
