module VagrantCloner
  module Cloners
    class MysqlCloner < ::VagrantCloner::BaseCloner

      attr_accessor   :remote_host, :remote_user, :remote_password,
                      :remote_db_user, :remote_db_password, :use_ssh,
                      :vm_db_user, :vm_db_password,
                      :databases_to_clone,
                      :remote_backup_path, :local_backup_path, :vm_backup_path, :backup_file,
                      :disable_cleanup, :warned_about_password

      def name
        "mysql"
      end

      def validate(machine, errors)
        failures = []
        failures.push "Must specify a remote user and host." unless remote_user && remote_host
        failures.push "Must specify a remote database user and password." unless (remote_db_user && remote_db_password) || use_ssh
        unless warned_about_password or remote_password
          machine.env.ui.warn "You haven't specified a remote password. Pulling down MySQL databases may fail unless you have proper publickey authentication enabled."
          @warned_about_password = true
        end
        errors.merge(name.to_sym => failures) if failures.any?
      end

      def remote_credentials
        return @remote_credentials unless @remote_credentials.nil?

        creds = [@remote_host, @remote_user]
        creds.push :password => remote_password if remote_password
        creds
      end

      def databases_to_clone
        @databases_to_clone ||= []
      end

      def remote_backup_path
        @remote_backup_path ||= "/tmp"
      end

      def local_backup_path
        @local_backup_path ||= "/tmp"
      end

      def vm_backup_path
        @vm_backup_path ||= "/tmp"
      end

      def disable_cleanup
        @disable_cleanup.nil? ? false : @disable_cleanup
      end
      alias_method :disable_cleanup?, :disable_cleanup

      def use_ssh
        @use_ssh.nil? ? true : @use_ssh
      end
      alias_method :use_ssh?, :use_ssh


      def extract_relevant_options
        @enabled                = options.enabled
        @remote_host            = options.remote_host
        @remote_user            = options.remote_user
        @remote_password        = options.remote_password
        @remote_db_user         = options.remote_db_user
        @remote_db_password     = options.remote_db_password

        @use_ssh                = options.use_ssh

        @databases_to_clone     = options.databases_to_clone

        @vm_db_user             = options.vm_db_user
        @vm_db_password         = options.vm_db_password

        @remote_credentials     = options.remote_credentials

        @remote_backup_path     = options.remote_backup_path
        @local_backup_path      = options.local_backup_path
        @vm_backup_path         = options.vm_backup_path
        @backup_file            = options.backup_file || "mysql-backup-#{datestring}.sql"

        @remote_backup_location = File.join(remote_backup_path, @backup_file)
        @local_backup_location  = File.join(local_backup_path, @backup_file)
        @vm_backup_location     = File.join(vm_backup_path, @backup_file)
      end

      def mysql_database_flag
        if @databases_to_clone.include?("*") || @databases_to_clone.empty?
          "--all-databases"
        else
          "--databases #{Array(@databases_to_clone).join(' ')}"
        end
      end

      # We don't want to output -p if password is nil, because that will prompt
      # for a password.
      def mysql_password_flag(password)
        if password.nil? || password.empty?
          ""
        else
          %Q{ -p"#{password}"}
        end
      end

      def call
        extract_relevant_options
        if use_ssh?
          dump_remote_database
          download_remote_database
          import_database
          clean_up
        else
          remote_dump_and_pipe
        end
      end

      def remote_dump_and_pipe
        info "Doing remote mysqldump..."
        command = %Q{mysqldump --verbose -h #{@remote_host} -u"#{@remote_user}"#{mysql_password_flag(@remote_password)} #{mysql_database_flag} | mysql -u"#{@vm_db_user}"#{mysql_password_flag(@vm_db_password)}"}
        vm.tap do |host|
          vm.execute command
        end
        info "All done!"
      end

      def dump_remote_database
        command = %Q{mysqldump -u"#{@remote_db_user}"#{mysql_password_flag(@remote_db_password)} #{mysql_database_flag} > #{@remote_backup_location}}
        ssh(*remote_credentials) {|s| s.exec! command }
        info "Finished dumping database!"
      end

      def download_remote_database
        scp(*remote_credentials) {|s| s.download! @remote_backup_location, @local_backup_path }
        info "Finished downloading file."
      end

      def import_database
        vm.tap do |host|
          host.upload @local_backup_location, @vm_backup_location
          command = %Q{mysql -u"#{@vm_db_user}"#{mysql_password_flag(@vm_db_password)} < #{@vm_backup_location}}
          host.execute command
        end
        info "Done loading database."
      end

      def clean_up
        unless disable_cleanup?
          ssh(*remote_credentials) {|s| s.exec! "rm #{@remote_backup_location}" } and info "Removed remote backup file."
          system "rm #{@local_backup_location}" and info "Removed local backup file."
          vm.execute "rm #{@vm_backup_location}" and info "Removed vm backup file."
          success "Done!"
        end
      end
    end
  end
end

if defined? VagrantCloner::ClonerContainer
  VagrantCloner::ClonerContainer.instance.send("#{VagrantCloner::Cloners::MysqlCloner.instance.name}=".to_sym, VagrantCloner::Cloners::MysqlCloner.instance)
end
