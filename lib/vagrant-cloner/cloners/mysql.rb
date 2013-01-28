module Vagrant
  module Cloners
    class MysqlCloner < Cloner
      attr_reader :remote_credentials

      def initialize(options, env)
        @env                    = env

        @remote_host            = options.remote_host
        @remote_user            = options.remote_user
        @remote_password        = options.remote_password
        @remote_db_user         = options.remote_db_user
        @remote_db_password     = options.remote_db_password

        @databases_to_clone     = options.databases_to_clone

        @vm_db_user          = options.vm_db_user
        @vm_db_password      = options.vm_db_password

        @remote_credentials  = options.remote_credentials || [@remote_host, @remote_user, {:password => @remote_password}]

        # TODO: We should probably check these exist
        @remote_backup_path     = options.remote_backup_path || "/home/#{@remote_user}"
        @local_backup_path      = options.local_backup_path || File.expand_path(".")
        @vm_backup_path         = options.vm_backup_path || "/vagrant"
        @backup_file            = options.backup_file || "mysql-backup-#{datestring}.sql"

        @remote_backup_location = File.join(@remote_backup_path, @backup_file)
        @local_backup_location  = File.join(@local_backup_path, @backup_file)
        @vm_backup_location     = File.join(@vm_backup_path, @backup_file)
      end

      def mysql_database_flag
        if @databases_to_clone.include?("*") || @databases_to_clone.empty?
          "--all-databases"
        else
          "--databases #{Array(@databases_to_clone).join(' ')}"
        end
      end

      def call
        dump_remote_database
        download_remote_database
        import_database
        clean_up
      end

      def dump_remote_database
        command = "mysqldump -u#{@remote_db_user} -p#{@remote_db_password} #{mysql_database_flag} > #{@remote_backup_location}"
        ssh {|s| s.exec! command }
        info "Finished dumping database!"
      end

      # TODO: Check if file already exists locally. If it does, use that. We should clean this up on each
      # subsequent invocation of the provisioner.
      def download_remote_database
        scp {|s| s.download! @remote_backup_location, @local_backup_path }
        info "Finished downloading file."
      end

      def import_database
        vm.upload @local_backup_location, @vm_backup_path
        vm.execute "mysql -u#{@vm_db_user} -p#{@vm_db_password} < #{@vm_backup_location}"
        info "Done loading database."
      end

      # TODO: Do this at the start of every invocation?
      def clean_up
        ssh {|s| s.exec! "rm #{@remote_backup_location}" }
        info "Removed remote backup file."

        system "rm #{@local_backup_location}"
        info "Removed local backup file."

        # TODO: Find out why this is unnecessary. This file shouldn't be removed. Where does it go?!
        #vm.execute "rm #{@vm_backup_location}"
        info "Done!"
      end
    end
  end
end
