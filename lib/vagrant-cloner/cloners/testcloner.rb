module VagrantCloner
  module Cloners
    class TestCloner < ::VagrantCloner::BaseCloner
      attr_accessor :foo

      def name
        "testcloner"
      end

      def validate(machine, errors)
        failures = []
        failures.push "Must specify a foo" unless foo

        failures.merge(name.to_sym => failures) if failures.any?
      end

      def call
        info "Foo is #{foo}"
      end
    end
  end
end

VagrantCloner::ClonerContainer.instance.send("#{VagrantCloner::Cloners::TestCloner.instance.name}=".to_sym, VagrantCloner::Cloners::TestCloner.instance)

# Inside your vagrant file, make sure you add the section for this cloner!
#  # ...
#
#  config.vm.provision :cloner do |cfg|
#    cfg.cloners.testcloner.tap do |c|
#      c.enabled = true
#      c.foo = "Roses are red, violets are foo."
#    end
#  end
