module Vagrant
  module Dbclone
    class Config < Vagrant::Config::Base
      attr_accessor :remote_server, :remote_port, :remote_user, :remote_password
      attr_accessor :remote_db_user, :remote_db_password
      attr_accessor :databases_to_backup

      attr_accessor :local_db_user, :local_db_password

      def remote_port
        @remote_port.nil? ? (@remote_port = 22) : @remote_port.to_i
      end

      def databases_to_backup
        @databases_to_backup.nil? ? (@databases_to_backup = '*') : @databases_to_backup
      end

      def validate(env, errors)
        errors.add('Remote server must be specified.') unless remote_server
        errors.add('Remote user/password must be specified.') unless remote_user && remote_password
        errors.add('Remote database user/password must be specified.') unless remote_db_user && remote_db_password
        errors.add('Local database user/password must be specified.') unless local_db_user && local_db_password
      end
    end
  end
end

Vagrant.config_keys.register(:dbclone) { Vagrant::Dbclone::Config }
