require 'optparse'
module VagrantPlugins
  module CommandRSYNC
    class Command < Vagrant.plugin("2", :command)

      class RsyncNotAvailableError < Vagrant::Errors::VagrantError
        error_namespace("vagrant.plugin.vagrant-rsync")
      end

      def verify_rsync(vm)

        begin
          vm.communicate.execute("rsync")
        rescue
          case vm.guest.detect!
          when :debian, :ubuntu
            vm.communicate.sudo("apt-get update")
            vm.communicate.sudo("apt-get install rsync")
          when :fedora, :centos, :redhat
            vm.communicate.sudo("yum install rsync")
          when :suse
            vm.communicate.sudo("yast2 -i rsync")
          when :gentoo
            vm.communicate.sudo("emerge rsync")
          when :arch
            vm.communicate.sudo("pacman -s rsync")
          else
            raise RsyncNotAvailableError
          end
        end
      end

      def execute
        options = {}

        opts = OptionParser.new do |opt|
          opt.banner = "Usage: vagrant rsync [vm-name]"
          opt.on('--verbose') do |v|
            options[:verbose] = true
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

          verify_rsync(vm)

          vm.config.vm.synced_folders.each do |id, data|
            next if data[:nfs]
            hostpath  = File.expand_path(data[:hostpath], vm.env.root_path)
            hostpath = "#{hostpath}/" if hostpath !~ /\/$/
            guestpath = data[:guestpath]
            ssh_info  = vm.ssh_info

            rsync_options = "-aze --exclude #{vm.env.root_path}/.vagrant/ "
            rsync_options << '-vvv' if options[:verbose]

            command = [
              "rsync", "--verbose", "--delete", "--archive", "-z",
              "--exclude", ".vagrant/",
              "-e", "ssh -p #{ssh_info[:port]} -o StrictHostKeyChecking=no -i '#{ssh_info[:private_key_path]}'",
              hostpath,
              "#{ssh_info[:username]}@#{ssh_info[:host]}:#{guestpath}"]


            if options[:verbose]
              puts command.join(" ")
            end

            r = Vagrant::Util::Subprocess.execute(*command)
            if r.exit_code != 0
              raise Errors::RsyncError,
                :guestpath => guestpath,
                :hostpath => hostpath,
                :stderr => r.stderr
            end
          end
        end
      end
    end
  end
end
