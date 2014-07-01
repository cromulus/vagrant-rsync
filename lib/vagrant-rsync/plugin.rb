begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant AWS plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.1.0"
  raise "The Vagrant AWS plugin is only compatible with Vagrant 1.1+"
end

# Add our custom translations to the load path
I18n.load_path << File.expand_path("../../../locales/en.yml", __FILE__)

module VagrantPlugins
  module Rsync
    class Plugin < Vagrant.plugin("2")
      name "rsync command"
      description <<-DESC
      THIS PLUGIN IS DEPRECATED: use a recent vagrant 1.5+ for rsync-ed folders.
      The `rsync` command allows you to sync the files in your working directories to the guest.
      DESC

      command("rsync") do
        
        require_relative 'command'
        Command
      end

      guest_capability("linux", "ensure_rsync") do
        require_relative "cap/ensure_rsync"
        Cap::EnsureRsync
      end

      guest_capability("linux", "rsync_folders") do
        require_relative "cap/rsync_folders"
        Cap::RsyncFolders
      end
    end
  end
end
