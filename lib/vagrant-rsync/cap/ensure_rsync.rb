require_relative '../errors'

module VagrantPlugins
  module Rsync
    module Cap
      class EnsureRsync

        def self.ensure_rsync(machine)
          return unless machine.communicate.ready?

          install_rsync!(machine) unless rsync_installed?(machine)
        end

        def self.rsync_installed?(machine)
          machine.communicate.execute("rsync --version") rescue false
        end

        def self.install_rsync!(machine)
          machine.communicate.tap do |comm|
            case machine.guest.name
            when :debian, :ubuntu
              comm.sudo "apt-get update"
              comm.sudo "apt-get install rsync"
            when :fedora, :centos, :redhat
              comm.sudo "yum install rsync"
            when :suse
              comm.sudo "yast2 -i rsync"
            when :gentoo
              comm.sudo "emerge rsync"
            when :arch
              comm.sudo "pacman -s rsync"
            else
              raise Errors::RsyncNotAvailableError, guest: machine.guest.name
            end
          end
        end

      end
    end
  end
end
