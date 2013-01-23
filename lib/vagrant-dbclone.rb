require 'vagrant'

require "vagrant-dbclone/provisioner"
require "vagrant-dbclone/config"

Vagrant.provisioners.register(:dbclone, Vagrant::Provisioners::Dbclone)
