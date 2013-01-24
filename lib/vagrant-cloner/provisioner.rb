module Vagrant
  module Provisioners
    class Cloner < Vagrant::Provisioners::Base

      def prepare
      end

      def provision!
        env[:ui].info "Vagrant-Cloner beginning back-up process."
        copy_assets if config.enabled
      end

      def copy_assets
      end
    end
  end
end
