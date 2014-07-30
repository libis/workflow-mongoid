# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), 'lib/libis/workflow/mongoid/version'))

Gem::Specification.new do |gem|
  gem.name = 'LIBIS_Worfklow_Mongoid'
  gem.version = ::LIBIS::Workflow::Mongoid::VERSION
  gem.date = Date.today.to_s

  gem.summary = %q{Mongoid persistence for the LIBIS Workflow framework.}
  gem.description = %q{Class implementations that use Mongoid storage for the LIBIS Workflow framework.}

  gem.author = 'Kris Dekeyser'
  gem.email = 'kris.dekeyser@libis.be'
  gem.homepage = 'https://github.com/libis/workflow-mongoid'
  gem.license = 'MIT'

  gem.files = `git ls-files -z`.split("\0")
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})

  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'LIBIS_Workflow', '1.0.2'
  gem.add_runtime_dependency 'mongoid'
  gem.add_runtime_dependency 'mongoid-indifferent-access'

  gem.add_development_dependency 'bundler', '~> 1.6'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'coveralls'

end
