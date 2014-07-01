# DEPRECATED! Vagrant Rsync Plugin
This is a [Vagrant](http://www.vagrantup.com) 1.1+ plugin that adds an rsync command to vagrant, allowing you to use a filesystem watcher to sync your shared directories with your guest machines.

**DEPRECATED**
Due to the release of vagrant 1.5, with it's build in rsync shared folders, this plugin is no longer needed. 

**NOTE:** This plugin requires Vagrant 1.1+, and [rsync](http://rsync.samba.org/)

Based off of [Vagrant-Sync](https://github.com/calavera/vagrant-sync)


## Features
* automatically detects all shared folders, on all named machines
* syncs em up.
* install rsync automatically on a variety of linux based guests. (turn off with --no-install)

## Usage

```bash
vagrant plugin install vagrant-rsync
....
vagrant rsync vm-name
...
```

The guest must be up and running.

Note: This plugin is meant for interacting with guests that are not running on your local machine.
I have no idea what will happen if you are sharing with NFS or virtualbox shared folders.
It might destroy all your data and turn your co-workers into angry badgers. Be forewarned.

If you'd like me to add new guests to the rsync auto-install, send me the command to install rsync, and I'll make it happen.

Can be mixed in with Guard or kicker or what-have-you to rsync whenever the host filesystem changes.

```bash
kicker -e "vagrant rsync" .
```

