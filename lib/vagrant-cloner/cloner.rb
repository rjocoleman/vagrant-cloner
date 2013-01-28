require 'vagrant'
require 'net/ssh'
require 'net/scp'
require 'date'

# We make this available to expose netssh to cloners.
Vagrant::Communication::SSH.send(:public, :connect)

module Vagrant
  module Cloners
    autoload :MysqlCloner, 'vagrant-cloner/cloners/mysql'

    # Cloner defines the base API that a cloner has to modify a VM or remote systems.
    # TODO: Create a method that downloads to local and then uploads to VM?
    #
    class Cloner
      # Shorthand for addressing the SSH communicator to the VM. View available methods
      # here:
      # https://github.com/mitchellh/vagrant/blob/master/plugins/communicators/ssh/communicator.rb
      def vm
        env[:vm].channel
      end

      # Opens an SSH connection to an arbitrary server and passes it to a supplied block.
      #
      # See netssh documentation for further method options.
      # http://net-ssh.github.com/net-ssh/
      def ssh(&block)
        Net::SSH.start(*remote_credentials, &block)
      end

      # Opens an SCP connection to an arbitrary server, downloading or uploading to the
      # machine currently in scope (whether the host machine or the VM).
      # Recommended params:
      #   remote_host, remote_user, {:password => remote_password}
      #
      # See netscp documentation for further method options.
      # https://github.com/net-ssh/net-scp
      def scp(&block)
        Net::SCP.start(*remote_credentials, &block)
      end

      # Makes the action environment accessible as 'env' simply.
      def env
        @env
      end
      protected :env

      # Returns the current date in YYYY-MM-DD format.
      def datestring
        Date.today.to_s
      end
      protected :datestring

      # Output a message.
      %w(info warn error success).each do |meth|
        define_method(meth) do |message|
          env[:ui].send(meth.to_sym, message)
        end
        protected meth.to_sym
      end

      def remote_credentials
        [@remote_host, @remote_user, {:password => @remote_password}]
      end
      protected :remote_credentials
    end
  end
end
