# Vagrant Rsync Plugin
This is a [Vagrant](http://www.vagrantup.com) 1.1+ plugin that adds an rsync command to vagrant, allowing you to use a filesystem watcher to sync your shared directories with your guest machines.

**NOTE:** This plugin requires Vagrant 1.1+,

## Features
* automatically detects all shared folders.
* syncs em up.

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

