require 'vagrant-cloner/cloner_container'

module VagrantCloner
  class Config < Vagrant.plugin("2", :config)
    class << self
      def registered_cloners
        @@registered_cloners ||= ::VagrantCloner::ClonerContainer.new
      end

      def register_cloner(instance)
        registered_cloners.send("#{instance.name}=".to_sym, instance)
      end
    end

    def cloners
      @@registered_cloners
    end

    def validate(machine)
      errors = {}
      cloners.select {|c| c.enabled? }.each do |cloner|
        cloner.validate!(machine, errors)
      end
    end
  end
end
