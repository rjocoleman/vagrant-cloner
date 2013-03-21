module VagrantCloner
  class Config < Vagrant.plugin("2", :config)
    class << self
      attr_accessor :registered_cloners
    end

    def cloner
      self.class.registered_cloners ||= []
    end

    def validate(machine)
      errors = {}
      cloner.select {|c| c.enabled? }.each do |c|
        c.validate(machine, errors)
      end
      errors
    end
  end
end
