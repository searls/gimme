# -*- coding: utf-8 -*-
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
    gem.name = "gimme"
    gem.homepage = "http://github.com/searls/gimme"
    gem.license = "MIT"
    gem.summary = %Q{gimme — a low-specification test double library for Ruby}
    gem.description = %Q{gimme attempts to bring to Ruby a test double workflow akin to Mockito in Java. Major distinctions include preserving arrange-act-assert in tests, fast feedback for methods the double's real counterpart may not know how to respond to, no string/symbolic representations of methods, argument captors, and strong opinions (weakly held). }
    gem.email = "searls@gmail.com"
    gem.authors = ["Justin Searls"]
    # Include your dependencies below. Runtime dependencies are required when using your gem,
    # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
    #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
    gem.add_development_dependency "rspec", ">= 1.3.1"
    gem.add_development_dependency "cucumber", ">= 0.10.0"
  end
  Jeweler::RubygemsDotOrgTasks.new
rescue LoadError
  puts "`gem install jeweler` and run outside of bundler to do jeweler stuff. You can thank its dependency on bundler ~> 1.0.0 for this hack."
end

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gimme #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format progress}
end

Cucumber::Rake::Task.new('cucumber:wip') do |t|
  t.cucumber_opts = %w{--format progress --wip --tags @wip}
end


require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task :default => [:spec,:cucumber]
