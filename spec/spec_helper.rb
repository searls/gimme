require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'coveralls'
Coveralls.wear!

require 'gimme'
require 'rspec/given'

RSpec.configure do |config|
  config.mock_framework = Gimme::RSpecAdapter
end
