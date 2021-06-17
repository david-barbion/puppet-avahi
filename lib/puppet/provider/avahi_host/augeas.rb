Puppet::Type.type(:avahi_host).provide(:augeas, parent: Puppet::Type.type(:augeasprovider).provider(:default)) do
  desc 'Uses Augeas API to update an Avahi host entry.'

  default_file { '/etc/avahi/hosts' }

  lens { 'Hosts.lns' }

  confine feature: :augeas

  resource_path do |resource|
    "$target/*[canonical = '#{resource[:name]}']"
  end

  def self.instances
    augopen do |aug|
      resources = []
      aug.match("$target/*[label()!='#comment']").each do |spath|
        entry = {
          name:   aug.get("#{spath}/canonical"),
          ensure: :present,
          ip:     aug.get("#{spath}/ipaddr"),
        }
        resources << new(entry)
      end
      resources
    end
  end

  def create
    augopen! do |aug|
      aug.defnode('resource', "$target/#{next_seq(aug.match('$target/*'))}", nil)
      aug.set('$resource/ipaddr', resource[:ip])
      aug.set('$resource/canonical', resource[:name])
    end
  end

  def destroy
    augopen! do |aug|
      aug.rm('$resource')
    end
  end

  attr_aug_accessor(:ip, { label: 'ipaddr' })
end
