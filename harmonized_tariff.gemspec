# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'harmonized_tariff/version'

Gem::Specification.new do |spec|
  spec.name          = "harmonized_tariff"
  spec.version       = HarmonizedTariff::VERSION
  spec.authors       = ["Todd Treece"]
  spec.email         = ["toddtreece@gmail.com"]
  spec.description   = %q{A utility for converting the Harmonized Tariff Schedule from hts.usitc.gov to JSON, SQL, and XML.}
  spec.summary       = %q{Harmonized Tariff Schedule Converter}
  spec.homepage      = "http://github.com/toddtreece/harmonized_tariff"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["hts"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "activesupport"
  spec.add_dependency "builder"
  spec.add_dependency "heredoc_unindent"

end
