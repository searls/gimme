require 'simplecov'
SimpleCov.start

require 'gimme'
require 'rspec/given'

RSpec.configure do |config|
  config.mock_framework = Gimme::RSpecAdapter
end
