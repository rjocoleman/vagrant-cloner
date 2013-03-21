require 'ostruct'
require 'singleton'

module VagrantCloner
  class ClonerContainer < OpenStruct
    include Singleton
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
end
