# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'libis/workflow/mongoid/version'

mv_env = ENV['MONGOID_VERSION'] || '4.0'
mongoid_version = mv_env == 'master' ? '{github: "mongoid/mongoid"}' : "~> #{mv_env}"

Gem::Specification.new do |gem|
  gem.name = 'LIBIS_Workflow_Mongoid'
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

  gem.add_runtime_dependency 'LIBIS_Workflow', ::LIBIS::Workflow::Mongoid::VERSION # version numbers synchronised
  gem.add_runtime_dependency 'mongoid', mongoid_version
  gem.add_runtime_dependency 'mongoid-indifferent-access'

  gem.add_runtime_dependency 'sidekiq'
  if mv_env =~ /^3\./
    gem.add_runtime_dependency 'kiqstand'
  end

  gem.add_development_dependency 'bundler', '~> 1.6'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'coveralls'

end
