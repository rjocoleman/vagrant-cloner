module Vagrant
  module Provisioners
    class Cloner < Vagrant::Provisioners::Base

      def prepare
      end

      def provision!
        env[:ui].info "Vagrant-Cloner beginning back-up process."
        unless config.cloners.empty?
          config.cloners.each do |cloner|
            cloner = cloner.capitalize + "Cloner"
            if Vagrant::Cloners.constants.include?(cloner.to_sym) && (klass = Vagrant::Cloners.const_get(cloner)).is_a?(Class)
              klass.new(config, env).call
            else
              env[:ui].error "Cloner #{cloner} does not exist. Skipping."
            end
          end
        end
      end
    end
  end
end
