require 'spec_helper'

module Gimme
  describe InvocationStore do
    describe "incrementing calls" do
      When { 3.times { subject.increment(:some_double, :some_method, :some_args) } }
      Then { subject.get(:some_double, :some_method, :some_args).should == 3 }
    end
  end
end