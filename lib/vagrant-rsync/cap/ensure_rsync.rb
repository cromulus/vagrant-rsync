require_relative '../errors'

module VagrantPlugins
  module Rsync
    module Cap
      class EnsureRsync

        def self.rsync_installed?(machine)
          machine.communicate.execute("rsync --version")
        end

        def self.install_rsync(machine)
          machine.communicate.sudo case machine.guest.name
          when :debian, :ubuntu
            "apt-get update && apt-get install rsync"
          when :fedora, :centos, :redhat
            "yum install rsync"
          when :suse
            "yast2 -i rsync"
          when :gentoo
            "emerge rsync"
          when :arch
            "pacman -s rsync"
          else
            raise RsyncNotAvailableError
          end
        end

        def self.ensure_rsync(machine)
          return unless machine.communicate.ready?

          if rsync_installed?(machine)
            # TO DO: Figure out how to output in cap
            #env[:ui].info I18n.t('vagrant-rsync.action.installed')
          else
            #env[:ui].info I18n.t('vagrant-rsync.action.installing')
            install_rsync(machine)
          end
        end

      end
    end
  end
end
