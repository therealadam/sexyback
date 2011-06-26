require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = FileList["spec/**/*_spec.rb"]
end

desc 'Run all specs with Cassandra running'
RSpec::Core::RakeTask.new('spec:db') do |t|
  t.pattern = FileList["spec/**/*_spec.rb"]
  t.rspec_opts = '--tag @db'
end

desc 'Run all specs without Cassandra running'
RSpec::Core::RakeTask.new('spec:no_db') do |t|
  t.pattern = FileList["spec/**/*_spec.rb"]
  t.rspec_opts = '--tag ~@db'
end

task :default => [:spec]
