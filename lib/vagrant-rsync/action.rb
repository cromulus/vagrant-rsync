require_relative "action/ensure_rsync"
require_relative "action/rsync_folders"

module VagrantPlugins
  module Rsync
    module Action
      def self.ensure_rsync
        @ensure_rsync ||= ::Vagrant::Action::Builder.new.tap do |b|
          b.use EnsureRsync
        end
      end

      def self.rsync_folders
        @rsync_folders ||= ::Vagrant::Action::Builder.new.tap do |b|
          b.use RsyncFolders
        end
      end
    end
  end
end
