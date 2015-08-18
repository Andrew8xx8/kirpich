# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kirpich/version'

Gem::Specification.new do |spec|
  spec.name          = "kirpich"
  spec.version       = Kirpich::VERSION
  spec.authors       = ["Andreww8xx8"]
  spec.email         = ["avk@8xx8.ru"]

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "wrong"

  spec.add_dependency "slack-api"
  spec.add_dependency "nokogiri"
  spec.add_dependency "json"
  spec.add_dependency "fisher_classifier"
  spec.add_dependency "dante"
  spec.add_dependency "yandex_mystem"
end
