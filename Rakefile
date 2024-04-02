require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

desc 'run tests'
task :default => :spec

require 'github_changelog_generator/task'
GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'libis'
  config.project = 'workflow-mongoid'
  config.token = ENV['CHANGELOG_GITHUB_TOKEN']
  config.date_format = '%d/%m/%Y'
  config.unreleased = true
  config.verbose = false
end
