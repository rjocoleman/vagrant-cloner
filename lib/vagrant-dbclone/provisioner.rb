module Vagrant
  module Dbclone
    class Provisioner < Vagrant::Provisioners::Base

      def self.config_class
        Vagrant::Dbclone::Config
      end

      def prepare
      end

      def provision!
        env.ui.info "PROVISIONING WITH DBCLONE OMG OMG OMG"
      end
    end
  end
end

