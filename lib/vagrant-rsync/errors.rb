module VagrantPlugins
  module Rsync
    module Errors
      class RsyncNotAvailableError < Vagrant::Errors::VagrantError
        error_namespace("vagrant.plugin.vagrant-rsync")
      end
    end
  end
end

