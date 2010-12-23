require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "gimme"
  gem.homepage = "http://github.com/searls/gimme"
  gem.license = "MIT"
  gem.summary = %Q{A low-specification test double library for Ruby}
  gem.description = %Q{gimme attempts to bring to Ruby a test double workflow akin to Mockito in Java. Major distinctions include preserving arrange-act-assert in tests, fast feedback for methods the double's real counterpart may not know how to respond to, no string/symbolic representations of methods, argument captors, and strong opinions (weakly held). }
  gem.email = "searls@gmail.com"
  gem.authors = ["Justin Searls"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  gem.add_development_dependency "rspec", "> 1.3.1"
  gem.add_development_dependency "cucumber", "> 0.10.0"
end
Jeweler::RubygemsDotOrgTasks.new

require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end

task :default => :cucumber

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gimme #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
