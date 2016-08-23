require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  install_puppet
end

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      puppet_module_install(:source => proj_root, :module_name => 'avahi')
      on host, puppet('module','install','puppetlabs-stdlib'),   { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-firewall'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','bodgit-bodgitlib'),    { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','bodgit-dbus'),         { :acceptable_exit_codes => [0,1] }
    end
  end
end
