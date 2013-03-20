# In here:
# cloners = OpenStruct.new
#  cloners.mysql = MysqlCloner.config_class.new
#
# In readme:
# config.cloners.mysql.config_option = yes
#
# In provisioner
# config.cloners.any? {|k, v| v.enabled?}

require 'ostruct'

module VagrantCloner
  class ClonerContainer < OpenStruct
    include Enumerable
    def members
      methods(false).grep(/=/).map {|m| m[0...-1] }
    end

    def each
      members.each {|m| yield send(m) }
      self
    end

    def each_pair
      members.each {|m| yield m, send(m)}
      self
    end

    def enabled_by_order
      members.collect {|m| send(m)} # Get all plugin instances
        .select {|m| m.enabled? } # Only enabled
        .sort_by(&:run_order) # Sort by run order
        .each {|m| yield m} # Yield up
    end

  end

  class Plugin
    class ClonerConfig < Vagrant::Config::Base
      class << self
        def registered_cloners
          @@registered_cloners ||= ::VagrantCloner::ClonerContainer.new
        end

        def register_cloner(name, instance)
          registered_cloners.send("#{name}=".to_sym, instance)
        end
      end

      def cloners
        @@registered_cloners
      end

      def validate(env, errors)
        # errors.add('Remote server must be specified.') unless remote_host
        cloners.select {|c| c.enabled? }.each do |cloner|
          cloner.validate!(env, errors)
        end
      end
    end

    def self.config_class
      VagrantCloner::Plugin::ClonerConfig
    end
  end
end
