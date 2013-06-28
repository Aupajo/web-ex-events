# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'web_ex/events/version'

Gem::Specification.new do |spec|
  spec.name          = "web-ex-events"
  spec.version       = WebEx::Events::VERSION
  spec.authors       = ["Pete Nicholls"]
  spec.email         = ["pete@metanation.com"]
  spec.description   = "Allows fetching and parsing WebEx events through the WebEx API. Events can be queried and converted into JSON."
  spec.summary       = "A library to read WebEx events through the WebEx API."
  spec.homepage      = "https://github.com/Aupajo/web-ex-events"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "fakeweb"
  
  spec.add_dependency "tzinfo"
  spec.add_dependency "httparty"
  spec.add_dependency "nokogiri"
end
