require 'net/ssh'
require 'net/scp'
require 'date'

module Vagrant
  module Cloners
    autoload :MysqlCloner, 'vagrant-cloner/cloners/mysql'

    module Cloner
      def ssh(&block)
        Net::SSH.start(*options, &block)
        # Net::SSH.start(@remote_host, @remote_user, :password => @remote_password, &block)
      end

      def scp(&block)
        Net::SCP.start(*options, &block)
        # Net::SCP.start(@remote_host, @remote_user, :password => @remote_password, &block)
      end

      def vm_ssh(&block)
      end

      def info(message)
        env[:ui].info message
      end

      def datestring
        Date.today.to_s
      end
    end
  end
end

