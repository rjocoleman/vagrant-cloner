module Vagrant
  module Provisioners
    class Cloner < Vagrant::Provisioners::Base

      def prepare
      end

      def provision!
        env[:ui].info "Vagrant-Cloner beginning back-up process."
        config.cloners.enabled_by_order do |cloner|
          cloner.tap {|c|
            c.options = config.cloners.send(cloner.name)
            c.env = env
          }.call
        end
      end
    end
  end
end
