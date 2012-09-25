
Given /^we have this existing code:$/ do |string|
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

Then /^we should see a failure message that includes:$/ do |string|
  fail "expected a prior step to have raised error" unless @last_error
  @last_error.message.should include(string)
end