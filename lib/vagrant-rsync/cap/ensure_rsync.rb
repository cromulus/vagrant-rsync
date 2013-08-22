require_relative '../errors'

module VagrantPlugins
  module Rsync
    module Cap
      class EnsureRsync

        def self.ensure_rsync(machine)
          return unless machine.communicate.ready?

          if rsync_installed?(machine)
            # TO DO: Figure out how to output in cap
            #env[:ui].info I18n.t('vagrant-rsync.action.installed')
          else
            #env[:ui].info I18n.t('vagrant-rsync.action.installing')
            install_rsync!(machine)
          end
        end

        def self.rsync_installed?(machine)
          machine.communicate.execute("rsync --version")
        end

        def self.install_rsync!(machine)
          machine.communicate.sudo.tap do |comm|
            case machine.guest.name
            when :debian, :ubuntu
              comm "apt-get update"
              comm "apt-get install rsync"
            when :fedora, :centos, :redhat
              comm "yum install rsync"
            when :suse
              comm "yast2 -i rsync"
            when :gentoo
              comm "emerge rsync"
            when :arch
              comm "pacman -s rsync"
            else
              raise RsyncNotAvailableError
            end
          end
        end

      end
    end
  end
end
