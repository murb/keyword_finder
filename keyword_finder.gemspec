# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keyword_finder/version'

Gem::Specification.new do |spec|
  spec.name          = "keyword_finder"
  spec.version       = KeywordFinder::VERSION
  spec.authors       = ["murb"]
  spec.email         = ["info@murb.nl"]

  spec.summary       = "Find given set of keywords in a sentence."
  spec.description   = "Find given set of keywords in a sentence based on simple regex (nothing fuzzy), although some cleaning is being done"
  spec.homepage      = "https://murb.nl/blog?tags=keyword_finder"
  spec.license       = "MIT"



  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
