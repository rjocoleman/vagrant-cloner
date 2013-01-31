require 'net/ssh'
require 'net/scp'
require 'date'
require 'singleton'

module Vagrant
  module Cloners
    # Cloner defines the base API that a cloner has to modify a VM or remote systems.
    # TODO: Create a method that downloads to local and then uploads to VM?

    class Cloner
      include Singleton

      attr_accessor :enabled, :env, :options

      def name
        raise "Cloner must define #name and return a string."
      end

      def validate!
        true
      end

      def enabled?
        @enabled.nil? ? false : @enabled
      end

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
      def ssh(*args, &block)
        Net::SSH.start(*args, &block)
      end

      # Opens an SCP connection to an arbitrary server, downloading or uploading to the
      # machine currently in scope (whether the host machine or the VM).
      # Recommended params:
      #   remote_host, remote_user, {:password => remote_password}
      #
      # See netscp documentation for further method options.
      # https://github.com/net-ssh/net-scp
      def scp(*args, &block)
        Net::SCP.start(*args, &block)
      end

      def datestring
        Date.today.to_s
      end
      protected :datestring

      # Wrap debugging options.
      %w(info warn error success).each do |meth|
        define_method(meth) do |message|
          env[:ui].send(meth.to_sym, message)
        end
        protected meth.to_sym
      end
    end
  end
end
