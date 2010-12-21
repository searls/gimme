Given /^a new test double$/ do
  @double = gimme(Object)
end

When /^I stub the to_s method to return "([^"]*)"$/ do |result|
  were(@double).to_s { result }
end

Then /^invoking to_s returns "([^"]*)"$/ do |result|
  @double.to_s.should == result
end

When /^I invoke (.*)(\(.*\))?$/ do |method,args|
  puts method + ' with ' + (args||'')
  if !args
    @double.send(method.to_sym)
  else
    @double.send(method.to_sym,args.to_a(','))
  end
end

Given /^I do not invoke (.*)(\(.*\))?$/ do |method,args|
end

Then /^invoking (.*) raises a (.*)$/ do |method,error_type|
  expect_error(eval(error_type)) { @double.send(method.to_sym) }
end

Then /^verifying (.*) raises a (.*)$/ do |method,error_type|
  expect_error(eval(error_type)) { verify(@double).send(method.to_sym) }
end

Then /^I can verify (.*)(\(.*\))? has been invoked$/ do |method,args|
  if !args
    verify(@double).send(method.to_sym)
  else
    verify(@double).send(method.to_sym,args.to_a(','))
  end
end

Then /^I can verify (.*)(\(.*\))? has been invoked (\d+) times?$/ do |method,args,times|
  verifier = verify(@double,times.to_i)
  if !args
    verifier.send(method.to_sym)
  else
    verifier.send(method.to_sym,args.to_a(','))
  end
end

def expect_error(type,&block)
  rescued = false
  begin
    yield
  rescue type
    rescued = true
  end
  rescued.should be true
end
