module Vagrant
  module Provisioners
    class Cloner

      class ClonerConfig < Vagrant::Config::Base
        attr_accessor :cloners

        attr_accessor :remote_host, :remote_user, :remote_password
        attr_accessor :remote_db_user, :remote_db_password
        attr_accessor :databases_to_clone

        attr_accessor :local_db_user, :local_db_password

        attr_accessor :database_provider
        attr_accessor :remote_backup_path, :local_backup_path, :backup_file

        def databases_to_clone
          @databases_to_clone.nil? ? (@databases_to_clone = '*') : @databases_to_clone
        end

        def enabled
          @enabled.nil? ? false : @enabled
        end

        def validate(env, errors)
          if cloners.any?
            errors.add('Remote server must be specified.') unless remote_host
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
