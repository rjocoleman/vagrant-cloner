module Vagrant
  module Dbclone
    class Middleware

      def initialize(app, env)
        @app = app
        @env = env
      end

      def call(env)
        @env = env
        #vm = env[:vm]
        #options = vm.config.dbclone.to_hash
        env[:ui].info "HELLO FROM DBCLONE!"
        #env[:ui].info options.inspect

        @app.call(env)
      end

    end
  end
end

Vagrant.actions[:start].insert_after Vagrant::Action::VM::Provision, Vagrant::Dbclone::Middleware
