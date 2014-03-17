require_relative '../errors'

module VagrantPlugins
  module Rsync
    module Cap
      class EnsureRsync

        def self.ensure_rsync(machine, env)
          return unless machine.communicate.ready?

          if rsync_installed?(machine)
            env.ui.info I18n.t('vagrant_rsync.rsync_installed')
          else
            env.ui.info I18n.t('vagrant_rsync.installing_rsync')
            install_rsync!(machine)
          end
        end

        def self.rsync_installed?(machine)
          machine.communicate.execute("rsync --version") rescue false
        end

        def self.install_rsync!(machine)
          machine.communicate.tap do |comm|
            case machine.guest.name
            when :debian, :ubuntu
              comm.sudo "apt-get update"
              comm.sudo "apt-get install rsync -y"
            when :fedora, :centos, :redhat
              comm.sudo "yum install rsync -y"
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
