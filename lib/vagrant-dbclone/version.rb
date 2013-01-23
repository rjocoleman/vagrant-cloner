module Vagrant
  module Dbclone
    class Version
      @major = 0
      @minor = 0
      @tiny  = 4

      class << self
        attr_reader :major, :minor, :tiny

        def to_s
          [@major, @minor, @tiny].compact.join('.')
        end
      end
    end
  end
end
