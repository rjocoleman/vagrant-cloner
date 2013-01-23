require 'vagrant'

require "vagrant-cloner/provisioner"
require "vagrant-cloner/config"

Vagrant.provisioners.register(:cloner, Vagrant::Provisioners::Cloner)
