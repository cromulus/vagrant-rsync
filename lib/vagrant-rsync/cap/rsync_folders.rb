module VagrantPlugins
  module Rsync
    module Cap
      class RsyncFolders
        def self.rsync_folders(machine)
          machine.config.vm.synced_folders.each do |id, data|
            next if data[:nfs]

            hostpath  = File.expand_path(data[:hostpath], machine.env.root_path)
            hostpath = "#{hostpath}/" if hostpath !~ /\/$/
            guestpath = data[:guestpath]
            ssh_info  = machine.ssh_info

            command = [
              "rsync", "--verbose", "--delete", "--archive", "-z",
              "--exclude", ".vagrant/",
              "-e", "ssh -p #{ssh_info[:port]} -o StrictHostKeyChecking=no -i '#{ssh_info[:private_key_path]}'",
              hostpath,
              "#{ssh_info[:username]}@#{ssh_info[:host]}:#{guestpath}"
            ]

            options = {}
            command << '-vvv' if options[:verbose]

            if options[:verbose]
              ## should the vagrant way of outputting text
              #@env.ui.say(:info,command.join(" "))
            end

            r = Vagrant::Util::Subprocess.execute(*command)
            #@env.ui.say(:info, "done") if options[:verbose]
            if r.exit_code != 0
              raise Errors::RsyncError,
                :guestpath => guestpath,
                :hostpath => hostpath,
                :stderr => r.stderr
            end
          end
        end
      end
    end
  end
end
