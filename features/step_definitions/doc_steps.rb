
Given /^we have this production code:$/ do |string|
  eval(string)
end

When /^we want to write some tests to help us write this method:$/ do |string|
  eval(string)
end

When /^we write a test we expect to fail:$/ do |string|
  begin
    eval(string)
  rescue
    @last_error = $!
  end

  unless @last_error
    fail "\nexpected this step's code to raise error, but it did not.\n\n"
  end
end

Then /^we can use gimme to isolate the unit under test:$/ do |string|
  eval(string)
end

Then /^this should work:$/ do |string|
  eval(string)
end

Then /^we should see a failure message that includes:$/ do |string|
  fail "expected a prior step to have raised error" unless @last_error
  @last_error.message.should include(string)
end

Given /^this RSpec will pass:$/ do |spec_code|
  run_spec_for(create_spec_file_for(spec_code))
end

def create_spec_file_for(spec_code)
  Tempfile.new('spec').tap do |file|
    file.write <<-RUBY
      require 'rspec'
      require 'rspec/given'
      require 'gimme'

      #{spec_code}
    RUBY
    file.close
  end
end

def run_spec_for(file)
  out = StringIO.new
  unless RSpec::Core::Runner.run([file.path], out, out) == 0
    out.rewind
    fail <<-RSPEC
***********************************
RSpec execution failed with output:
***********************************

#{out.read}
    RSPEC
  end
end