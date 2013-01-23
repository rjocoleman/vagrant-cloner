module Vagrant
  module Dbclone
    class Middleware

      def initialize(app, env)
        @app = app
        @env = env
      end

      def call(env)
        @env = env
        vm = env[:vm]
        options = vm.config.dbclone.to_hash
        puts options.inspect

        @app.call(env)
      end

    end
  end
end
