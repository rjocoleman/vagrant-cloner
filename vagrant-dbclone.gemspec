# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-dbclone/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-dbclone"
  gem.version       = Vagrant::Dbclone::Version.to_s
  gem.authors       = ["Rob Yurkowski"]
  gem.email         = ["rob@yurkowski.net"]
  gem.description   = %q{A plugin for vagrant to copy down remote databases.}
  gem.summary       = %q{A plugin for vagrant to copy down remote databases.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
