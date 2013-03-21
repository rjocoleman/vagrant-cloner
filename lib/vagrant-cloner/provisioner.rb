module VagrantCloner
  class Provisioner < Vagrant.plugin("2", :provisioner)
    def configure(cfg)
    end

    def provision
      @machine.env.ui.info "Vagrant-Cloner beginning back-up process."
      config.cloners.enabled_by_order do |cloner|
        cloner.tap {|c|
          c.options = config.cloners.send(cloner.name)
          c.machine = @machine
        }.call
      end
    end
  end
end
