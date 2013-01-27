require 'vagrant'
require 'vagrant-cloner/provisioner'
require 'vagrant-cloner/config'
require 'vagrant-cloner/cloner'

Vagrant.provisioners.register(:cloner, Vagrant::Provisioners::Cloner)
