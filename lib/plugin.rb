require "vagrant"

module VagrantPlugins
  module CommandSSH
    class Plugin < Vagrant.plugin("2")
      name "rsync command"
      description <<-DESC
      The `rsync` command allows you to sync the files in your working directories to the guest.
      DESC

      command("rsync") do
        require File.expand_path("../command", __FILE__)
        Command
      end
    end
  end
end
