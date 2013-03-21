module VagrantCloner
  class Provisioner < Vagrant.plugin("2", :provisioner)
    def provision
      @machine.env.ui.info "Vagrant-Cloner beginning back-up process."
      config.cloner.enabled_by_order do |cloner|
        cloner.tap {|c|
          c.options = config.cloner.send(cloner.name)
          c.machine = @machine
        }.call
      end
    end
  end
end
