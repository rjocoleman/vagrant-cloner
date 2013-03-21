module VagrantCloner
  class Plugin < ::Vagrant.plugin("2")
    name "Cloner"

    provisioner "cloner" do
      require 'vagrant-cloner/provisioner'
      require 'vagrant-cloner/config'
      # require 'vagrant-cloner/base_cloner'
      # Dir[File.join(File.dirname(__FILE__), 'vagrant-cloner', 'cloners', '*.rb')].each {|f| require f }
      ::VagrantCloner::Provisioner
    end
  end
end
