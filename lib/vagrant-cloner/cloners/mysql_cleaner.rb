module Etailer
  class MysqlCleanerCloner < ::VagrantCloner::BaseCloner
    attr_accessor :vm_db_user, :vm_db_password

    def name
      "mysqlcleaner"
    end

    def scripts
      @scripts ||= []
    end

    def scripts=(scripts)
      @scripts = Array(scripts).flatten
    end

    def validate!(env, errors)
      errors.add("You have to specify at least one script to run!") if scripts.nil? || scripts.empty?
      errors.add("You must specify a VM database user and password!") unless vm_db_user && vm_db_password
    end

    def mysql_connection_string
      "-u#{vm_db_user} -p#{vm_db_password}"
    end
      
    def call
      @scripts.each do |script|
        info "Fetching script #{script}..."
        basename = script.split("/").last
        vm.execute "wget #{script} -P /tmp"
        vm.execute "mysql #{mysql_connection_string} < /tmp/#{basename}"
      end
    end
  end
end

VagrantCloner::Plugin::ClonerConfig.register_cloner Etailer::MysqlCleanerCloner.instance.name, Etailer::MysqlCleanerCloner.instance
