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

module VagrantPlugins
  module CommandRSYNC
    class Plugin < Vagrant.plugin("2")
      name "rsync command"
      description <<-DESC
      The `rsync` command allows you to sync the files in your working directories to the guest.
      DESC

      command("rsync") do
        require File.expand_path("../command.rb", __FILE__)
        Command
      end
    end
  end
end
