require_relative '../errors'

module VagrantPlugins
  module Rsync
    module Action
      class EnsureRsync
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
        end

        def call(env)
          return unless @machine.communicate.ready?

          if rsync_installed?
            env[:ui].info I18n.t('vagrant-rsync.action.installed')
          else
            env[:ui].info I18n.t('vagrant-rsync.action.installing')
            install_rsync
          end

          @app.call(env)
        end

        def rsync_installed?
          require 'pp'
          pp @machine
          @machine.communicate.execute("rsync")
        end

        def install_rsync
          case @machine.guest.name
          when :debian, :ubuntu
            @machine.communicate.sudo("apt-get update")
            @machine.communicate.sudo("apt-get install rsync")
          when :fedora, :centos, :redhat
            @machine.communicate.sudo("yum install rsync")
          when :suse
            @machine.communicate.sudo("yast2 -i rsync")
          when :gentoo
            @machine.communicate.sudo("emerge rsync")
          when :arch
            @machine.communicate.sudo("pacman -s rsync")
          else
            raise RsyncNotAvailableError
          end
        end
      end
    end
  end
end
