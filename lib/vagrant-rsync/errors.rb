module VagrantPlugins
  module Rsync
    module Errors
      class VagrantRsyncError < Vagrant::Errors::VagrantError
         error_namespace("vagrant_rsync.errors")
       end

      class RsyncNotAvailableError < VagrantRsyncError
        error_key(:rsync_not_available)
      end

      class RsyncFailed < VagrantRsyncError
        error_key(:rsync_failed)
      end

    end
  end
end

