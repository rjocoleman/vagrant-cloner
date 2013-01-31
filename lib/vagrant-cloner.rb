require 'vagrant'
require 'vagrant-cloner/provisioner'
require 'vagrant-cloner/config'
require 'vagrant-cloner/cloner'

Dir[File.join(File.dirname(__FILE__), 'vagrant-cloner', 'cloners', '*.rb')].each {|f| require f }

Vagrant.provisioners.register(:cloner, Vagrant::Provisioners::Cloner)
