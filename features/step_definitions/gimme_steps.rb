include Gimme
METHOD_PATTERN = /([^\(]*)(\(.*\))?/

Given /^a new (.*)\s?test double$/ do | type |
  @double = type.empty? ? gimme(Object) : gimme(eval(type))
end

# Stubbing

When /^I stub #{METHOD_PATTERN} to return (.*)$/ do |method,args,result|
  send_and_trap_error(NoMethodError,give(@double),method,args,result)
end

When /^I stub! #{METHOD_PATTERN} to return (.*)$/ do |method,args,result|
  send_and_trap_error(NoMethodError,give!(@double),method,args,result)
end

# Invoking

Then /^invoking #{METHOD_PATTERN} returns (.*)$/ do |method,args,result|
  sendish(@double,method,args).should == eval(result)
end

When /^I invoke #{METHOD_PATTERN}$/ do |method,args|
  sendish(@double,method,args)
end

Given /^I do not invoke #{METHOD_PATTERN}$/ do |method,args|
end

Then /^invoking (.*) raises a (.*)$/ do |method,error_type|
  expect_error(eval(error_type)) { sendish(@double,method) }
end

# Verifying

Then /^verifying #{METHOD_PATTERN} raises a (.*)$/ do |method,args,error_type|
  expect_error(eval(error_type)) { verify(@double).send(method.to_sym) }
end

Then /^I can verify #{METHOD_PATTERN} has been invoked$/ do |method,args|
  sendish(verify(@double),method,args)
end

Then /^I can verify #{METHOD_PATTERN} has been invoked (\d+) times?$/ do |method,args,times|
  sendish(verify(@double,times.to_i),method,args)
end

Then /^I can verify! #{METHOD_PATTERN} has been invoked (\d+) times?$/ do |method,args,times|
  sendish(verify!(@double,times.to_i),method,args)
end


# Exceptions
Then /^a (.*) is raised$/ do |error_type|
  @error.should be_a_kind_of eval(error_type)
  @error = nil
end

# Helpers

def send_and_trap_error(error_type,target,method,args=nil,result=nil)
  begin 
    sendish(target,method,args,result)
  rescue error_type => e
    @error = e
  end
end

def sendish(target,method,args=nil,result=nil)
    eval("target.#{method}#{args} { #{result} }")
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
