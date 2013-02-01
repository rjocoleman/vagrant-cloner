# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

version = '0.9.1'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-cloner"
  gem.version       = version
  gem.authors       = ["Robert Coleman", "Rob Yurkowski"]
  gem.email         = ["github@robert.net.nz", "rob@yurkowski.net"]
  gem.description   = %q{Copy production resources down to your new VM.}
  gem.summary       = %q{Copy production resources down to your new VM.}
  gem.homepage      = "https://github.com/robyurkowski/vagrant-cloner/"

  gem.files         = `git ls-files`.split($/)
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
