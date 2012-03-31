source "http://rubygems.org"
# Add dependencies required to use your gem here.

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development, :test do
  gem 'pry'

  gem 'rdoc'
  gem 'rake'

  gem "rspec"
  gem "rspec-given"
  gem "cucumber"
  gem "simplecov", :require => false

  gem "guard-cucumber", :require => false
  gem "guard-rspec", :require => false
  if RUBY_PLATFORM =~ /darwin/i
    gem "growl"
    gem "rb-fsevent", :require => false
  end
end
