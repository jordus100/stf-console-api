# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stf/version'

Gem::Specification.new do |spec|
  spec.name     = 'smartdust-client'
  spec.version  = Stf::VERSION
  spec.authors  = ['Smartdust']
  spec.email    = ['jordan@smartdust.me']
  spec.summary  = %q{Connect to devices from Smartdust Lab via adb from cli}
  spec.homepage = 'https://github.com/jordus100/stf-client'
  spec.license  = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']
  spec.executables   = ['smartdust-client']

  spec.add_runtime_dependency 'gli', '~> 2.17'
  spec.add_runtime_dependency 'ADB', '~> 0.5'
  spec.add_runtime_dependency 'dante', '~> 0.2.0'
  spec.add_runtime_dependency 'dry-container', '~> 0.6.0'
  spec.add_runtime_dependency 'dry-configurable', '~> 0.1.4'
  # spec.add_runtime_dependency 'pry', '~> 0.10.4'
  spec.add_runtime_dependency 'facets', '~> 3.1.0'

  spec.add_development_dependency 'bundler', '~> 1.16.a'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.2'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'sinatra', '~> 1.4'
  spec.add_development_dependency 'simplecov', '~> 0.14'
  spec.add_development_dependency 'simplecov-json', '~> 0.2'
end
