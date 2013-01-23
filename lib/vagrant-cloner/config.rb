module Vagrant
  module Provisioners
    class Cloner

      class ClonerConfig < Vagrant::Config::Base
        attr_accessor :remote_server, :remote_port, :remote_user, :remote_password
        attr_accessor :remote_db_user, :remote_db_password
        attr_accessor :databases_to_backup

        attr_accessor :local_db_user, :local_db_password

        attr_accessor :enabled

        def remote_port
          @remote_port.nil? ? (@remote_port = 22) : @remote_port.to_i
        end

        def databases_to_backup
          @databases_to_backup.nil? ? (@databases_to_backup = '*') : @databases_to_backup
        end

        def enabled
          @enabled.nil? ? false : @enabled
        end

        def validate(env, errors)
          if enabled
            errors.add('Remote server must be specified.') unless remote_server
            errors.add('Remote user/password must be specified.') unless remote_user && remote_password
            errors.add('Remote database user/password must be specified.') unless remote_db_user && remote_db_password
            errors.add('Local database user/password must be specified.') unless local_db_user && local_db_password
          end
        end
      end

      def self.config_class
        Vagrant::Provisioners::Cloner::ClonerConfig
      end
    end
  end
end
