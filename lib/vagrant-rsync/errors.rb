module VagrantPlugins
  module Rsync
    module Errors
      class RsyncNotAvailableError < Vagrant::Errors::VagrantError
        error_key(:rsync_not_available)
      end
    end
  end
end

