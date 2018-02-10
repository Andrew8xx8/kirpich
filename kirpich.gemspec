# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kirpich/version'

Gem::Specification.new do |spec|
  spec.name          = 'kirpich'
  spec.version       = Kirpich::VERSION
  spec.authors       = ['Andreww8xx8']
  spec.email         = ['avk@8xx8.ru']

  spec.summary       = 'Write a short summary, because Rubygems requires one.'
  spec.description   = 'Write a longer description or delete this line.'
  spec.homepage      = "https://github.com/Andrew8xx8/kirpich"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'pry-inline'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'wrong'
  spec.add_development_dependency 'awesome_print'

  spec.add_dependency 'virtus'
  spec.add_dependency 'slack-api'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'json'
  spec.add_dependency 'dante'
  spec.add_dependency 'logstash-logger'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'rake'
  spec.add_dependency 'twitter'
  spec.add_dependency 'telegram-bot-ruby'
end
