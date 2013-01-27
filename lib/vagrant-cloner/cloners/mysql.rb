module Vagrant
  module Cloners
    class MysqlCloner
      include Cloner

      def initialize(options)
        @remote_host            = options.remote_host
        @remote_user            = options.remote_user
        @remote_password        = options.remote_password
        @remote_db_user         = options.remote_db_user
        @remote_db_password     = options.remote_db_password

        @databases_to_clone     = options.databases_to_clone

        @local_db_user          = options.local_db_user
        @local_db_password      = options.local_db_password

        # TODO: We should probably check these exist
        @remote_backup_path     = options.remote_backup_path || "/home/#{@remote_user}"
        @local_backup_path      = options.local_backup_path || File.expand_path(".")
        @backup_file            = options.backup_file || "mysql-backup-#{datestring}.sql"

        @remote_backup_location = File.join(@remote_backup_path, @backup_file)
        @local_backup_location  = File.join(@local_backup_path, @backup_file)
      end

      def mysql_database_flag
        if @databases_to_clone == '*'
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
        ssh do |s|
          command = "mysqldump -u#{@remote_db_user} -p#{@remote_db_password} #{mysql_database_flag} > #{@remote_backup_location}"
          info " >> #{command}"
          s.exec! command
          info "Finished dumping database!"
        end
      end

      def download_remote_database
        scp do |s|
          info " >> net/scp #{@remote_backup_location}, #{@local_backup_path}"
          s.download! @remote_backup_location, @local_backup_path
          info "Finished downloading file."
        end
      end

      def import_database
        command = "mysql -u#{@local_db_user} -p#{@local_db_password} < #{@local_backup_location}"
        info " >> #{command}"
        system command
        info "Done loading database."
      end

      def clean_up
        info "Cleaning up."
        ssh do |s|
          s.exec! "rm #{@remote_backup_location}"
          info "Removed remote backup file."
        end
        system "rm #{@local_backup_location}"
        info "Done!"
      end
    end
  end
end
