# frozen_string_literal: true

require 'bundler'

if Bundler.rubygems.find_name('puppet_litmus').any?
  require 'rake'
  namespace :litmus do
    require 'puppet_litmus/inventory_manipulation'

    desc 'fix up sudo configuration on all or a specified set of targets'
    task :sudo_fix, [:target_node_name] do |_task, args|
      inventory_hash = inventory_hash_from_inventory_file
      target_nodes = find_targets(inventory_hash, args[:target_node_name])
      if target_nodes.empty?
        puts 'No targets found'
        exit 0
      end
      require 'bolt_spec/run'
      include BoltSpec::Run
      Rake::Task['spec_prep'].invoke
      bolt_result = run_command('printf "PATH=/sbin:/bin:/usr/sbin:/usr/bin\\n" >/etc/environment && printf "Defaults env_keep += \\"PATH\\"\\nDefaults exempt_group += vagrant\\n" >/etc/sudoers.d/litmus', target_nodes, config: nil, inventory: inventory_hash.clone)
      raise_bolt_errors(bolt_result, 'Fix of sudo configuration failed.')
      bolt_result
    end
  end
end
