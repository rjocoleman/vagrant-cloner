require 'vagrant-cloner/cloner_container'
require 'vagrant-cloner/base_cloner'
Dir[File.join(File.dirname(__FILE__), 'cloners', '*.rb')].each {|f| require f }

module VagrantCloner
  class Plugin < ::Vagrant.plugin("2")
    name "Cloner"

    config(:cloner, :provisioner) do
      require 'vagrant-cloner/config'
      ::VagrantCloner::Config.tap do |c| 
        c.registered_cloners = ::VagrantCloner::ClonerContainer.instance
      end
    end

    provisioner(:cloner) do
      require 'vagrant-cloner/provisioner'
      ::VagrantCloner::Provisioner
    end

  end
end
