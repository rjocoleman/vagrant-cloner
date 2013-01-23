require "vagrant-dbclone/version"

require "vagrant-dbclone/config"
require "vagrant-dbclone/middleware"

Vagrant.config_keys.register(:dbclone) { Vagrant::Dbclone::Config }

Vagrant.actions[:provision].use Vagrant::Dbclone::Middleware
