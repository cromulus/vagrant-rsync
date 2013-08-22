require 'optparse'

module VagrantPlugins
  module Rsync
    class Command < Vagrant.plugin("2", :command)
      def execute
        options = {}
        options[:install_rsync] = true
        options[:verbose] = false

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant rsync [vm-name]"

          o.on("-n", "--no-install", "Do not attempt to install rysnc if not found") do |ni|
            options[:install_rsync] = !ni
          end

          o.on('-v', '--verbose', "Run verbosely") do |v|
            options[:verbose] = v
          end

          o.on( '-h', '--help', 'Display this screen' ) do
            puts opts
            exit
          end
        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        with_target_vms(argv) do |vm|
          raise Vagrant::Errors::VMNotCreatedError if vm.state.id == :not_created
          raise Vagrant::Errors::VMInaccessible if vm.state.id == :inaccessible
        end

        with_target_vms(argv) do |machine|
          if options[:install_rsync]
            @env.ui.info I18n.t('vagrant_rsync.ensure_rsync')
            machine.guest.capability(:ensure_rsync, @env)
          end

          @env.ui.info I18n.t('vagrant_rsync.rsync_folders')
          machine.guest.capability(:rsync_folders)
        end

      end
    end
  end
end
