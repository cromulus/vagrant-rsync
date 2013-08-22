require 'optparse'

module VagrantPlugins
  module Rsync
    class Command < Vagrant.plugin("2", :command)

      def execute
        options = {
          :install_rsync => true,
          :verbose => false
        }

        opts = OptionParser.new do |opt|
          opt.banner = "Usage: vagrant rsync [vm-name]"
          opt.on("-n", "--no-install", "Do not attempt to install rysnc if not found") do |v|
            options[:install_rsync] = false
          end
          opt.on('-v', '--verbose', "Run verbosely") do |v|
            options[:verbose] = true
          end
          opt.on( '-h', '--help', 'Display this screen' ) do
            puts opts
            exit
          end
        end

        argv = parse_options(opts)
        unless argv
          argv=["default"]
        end

        with_target_vms(argv) do |vm|
          raise Vagrant::Errors::VMNotCreatedError if vm.state.id == :not_created
          raise Vagrant::Errors::VMInaccessible if vm.state.id == :inaccessible
        end

        with_target_vms(argv) do |vm|
          if options[:install_rsync]
            vm.guest.capability(:ensure_rsync)
          end

          vm.guest.capability(:rsync_folders)

        end
      end
    end
  end
end
