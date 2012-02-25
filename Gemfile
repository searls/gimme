source "http://rubygems.org"
# Add dependencies required to use your gem here.

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem 'rdoc'
  
  gem "jeweler", "~> 1.5.2"
  gem "rspec"
  gem "rspec-given"
  gem "guard-rspec", :require => false
  gem "cucumber"
  gem "guard-cucumber", :require => false
  gem "simplecov", :require => false
  if RUBY_PLATFORM =~ /darwin/i
    gem "growl_notify"
    gem "rb-fsevent", :require => false
  end
end
