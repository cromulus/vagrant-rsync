require 'optparse'

module VagrantPlugins
  module CommandRsync
    class Command < Vagrant.plugin("2", :command)
      def execute
        options = {}

        opts = OptionParser.new do |opt|
          opt.banner = "Usage: vagrant rsync [vm-name]"

          opt.on('--verbose') do |v|
            options[:verbose] = true
          end
        end

        argv = parse_options(opts)
        return unless argv

        with_target_vms(argv) do |vm|
          raise Vagrant::Errors::VMNotCreatedError if !vm.created?
          raise Vagrant::Errors::VMInaccessible if !vm.state == :inaccessible
        end

        with_target_vms(argv) do |vm|
          vm.synced_folders.each do |id, data|
            hostpath  = File.expand_path(data[:hostpath], env[:root_path])
            guestpath = data[:guestpath]
            ssh_info  = vm.ssh.info

            ssh_options = "-p#{ssh_info[:port]} -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oPasswordAuthentication=no -oIdentitiesOnly=yes -i#{ssh_info[:private_key_path]}"
            ssh_host    = "#{ssh_info[:username]}@#{ssh_info[:host]}:#{guestpath}"

            rsync_options = '-az'
            rsync_options << 'vvv' if options[:verbose]

            command = 'rsync %s --delete %s -e "ssh %s" %s' % [rsync_options, hostpath, ssh_options, ssh_host]
            puts command if options[:verbose]
            system(command)
          end
        end
      end
    end
  end
end
