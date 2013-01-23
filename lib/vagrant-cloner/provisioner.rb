module Vagrant
  module Provisioners
    class Cloner < Vagrant::Provisioners::Base

      def prepare
      end

      def provision!
        env.ui.info "PROVISIONING WITH CLONER OMG OMG OMG"
        env.ui.info "args: #{config.inspect}"
      end
    end
  end
end
