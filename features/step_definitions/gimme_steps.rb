METHOD_PATTERN = /([^\(]*)(\(.*\))?/

Given /^a new test double$/ do
  @double = gimme(Object)
end

When /^I stub #{METHOD_PATTERN} to return "([^"]*)"$/ do |method,args,result|
  were(@double).send(method.to_sym) { result }
end

Then /^invoking #{METHOD_PATTERN} returns "([^"]*)"$/ do |method,args,result|
  sendish(@double,method,args).should == result
end

When /^I invoke #{METHOD_PATTERN}$/ do |method,args|
  sendish(@double,method,args)
end

Given /^I do not invoke (.*)(\(.*\))?$/ do |method,args|
end

Then /^invoking (.*) raises a (.*)$/ do |method,error_type|
  expect_error(eval(error_type)) { sendish(@double,method) }
end

Then /^verifying #{METHOD_PATTERN} raises a (.*)$/ do |method,args,error_type|
  expect_error(eval(error_type)) { verify(@double).send(method.to_sym) }
end

Then /^I can verify #{METHOD_PATTERN} has been invoked$/ do |method,args|
  sendish(verify(@double),method,args)
end

Then /^I can verify #{METHOD_PATTERN} has been invoked (\d+) times?$/ do |method,args,times|
  sendish(verify(@double,times.to_i),method,args)
end

def sendish(target,method,args=nil,&block)
  args ? target.send(method.to_sym,argify(args)) : target.send(method.to_sym)
end

def argify(args)
  args ? args.to_a(',') : nil
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
