module VagrantCloner
  module Cloners
    class TestCloner < ::VagrantCloner::BaseCloner
      attr_accessor :foo

      def name
        "testcloner"
      end

      def validate!(env, errors)
        errors.add("Must specify a foo") unless foo
      end

      def call
        info "Foo is #{foo}"
      end
    end
  end
end

VagrantCloner::Plugin::ClonerConfig.register_cloner VagrantCloner::Cloners::TestCloner.instance.name, VagrantCloner::Cloners::TestCloner.instance

# Inside your vagrant file, make sure you add the section for this cloner!
#  # ...
#
#  config.vm.provision :cloner do |cfg|
#    cfg.cloners.testcloner.tap do |c|
#      c.enabled = true
#      c.foo = "Roses are red, violets are foo."
#    end
#  end
