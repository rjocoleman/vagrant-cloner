module Vagrant
  module Provisioners
    class Dbclone < Vagrant::Provisioners::Base

      def prepare
      end

      def provision!
        env.ui.info "PROVISIONING WITH DBCLONE OMG OMG OMG"
        env.ui.info "args: #{config.inspect}"
      end
    end
  end
end
