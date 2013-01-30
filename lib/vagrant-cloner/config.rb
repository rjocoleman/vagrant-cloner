module Vagrant
  module Provisioners
    class Cloner

      class ClonerConfig < Vagrant::Config::Base

                      # [Required] Which cloners should we use? (Empty array permitted)
        attr_accessor :cloners,

                      # [Required] The FQDN of the host where data is to be synced from
                      :remote_host,

                      # [Required] The username and password to access the remote host
                      :remote_user,
                      :remote_password,

                      # [Required] The database user and password to access the remote database
                      :remote_db_user,
                      :remote_db_password,

                      # [Required] The user and password to the database on the VM
                      :vm_db_user,
                      :vm_db_password,

                      # [Optional] The databases that we should clone
                      # - An empty array indicates we should clone all
                      # - An array containing '*' will clone all as well;
                      # - An array containing a list of database names will clone only those.
                      :databases_to_clone,

                      # [Optional] The location to temporarily store the database backup on the remote machine
                      :remote_backup_path,

                      # [Optional] The location to temporarily store the database backup on our machine
                      :local_backup_path,

                      # [Optional] The location to temporarily store the database backup on the VM
                      :vm_backup_path,

                      # [Optional] The name of the backup file
                      :backup_file,

                      # [Optional] Override to change the arguments passed to Net::SSH and Net::SCP.
                      :remote_credentials

        def remote_credentials
          [@remote_host, @remote_user, {:password => @remote_password}]
        end

        def databases_to_clone
          @databases_to_clone.nil? ? (@databases_to_clone = []) : @databases_to_clone
        end

        def remote_backup_path
          @remote_backup_path.nil? ? (@remote_backup_path = "/tmp") : @remote_backup_path
        end

        def local_backup_path
          @local_backup_path.nil? ? (@local_backup_path = "/tmp") : @local_backup_path
        end

        def vm_backup_path
          @vm_backup_path.nil? ? (@vm_backup_path = "/tmp") : @vm_backup_path
        end

        def validate(env, errors)
          if cloners.any?
            errors.add('Remote server must be specified.') unless remote_host
            errors.add('Remote user/password must be specified.') unless remote_user && remote_password
            errors.add('Remote database user/password must be specified.') unless remote_db_user && remote_db_password
            errors.add('VM database user/password must be specified.') unless vm_db_user && vm_db_password
          end
        end
      end

      def self.config_class
        Vagrant::Provisioners::Cloner::ClonerConfig
      end
    end
  end
end
