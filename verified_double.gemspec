# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verified_double/version'

Gem::Specification.new do |gem|
  gem.name          = "verified_double"
  gem.version       = VerifiedDouble::VERSION
  gem.authors       = ["George Mendoza"]
  gem.email         = ["gsmendoza@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "rspec"
  gem.add_runtime_dependency "rspec-fire"

  gem.add_development_dependency "pry"

end
