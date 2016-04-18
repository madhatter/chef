require 'bundler'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('site-cookbooks/**/spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation '
  t.rspec_opts << '--color '
end

task :default => :spec
