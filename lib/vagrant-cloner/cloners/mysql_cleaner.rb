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

    def validate(machine, errors)
      failures = []
      failures.push "You have to specify at least one script to run!" if scripts.nil? || scripts.empty?
      failures.push "You must specify a VM database user and password!" unless vm_db_user && vm_db_password

      errors.merge(name.to_sym => failures) if failures.any?
    end

    def mysql_connection_string
      "-u#{vm_db_user} -p#{vm_db_password}"
    end

    def call
      @scripts.each do |script|
        info "Fetching script #{script}..."
        basename = script.split("/").last
        vm.execute "curl #{script} -o /tmp/#{basename}"
        vm.execute "mysql #{mysql_connection_string} < /tmp/#{basename}"
      end
    end
  end
end

VagrantCloner::ClonerContainer.instance.send("#{Etailer::MysqlCleanerCloner.instance.name}=".to_sym, Etailer::MysqlCleanerCloner.instance)
