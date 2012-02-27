require 'spec_helper'

class Berry
  def ferment
  end

  private

  def grow
  end
end

module Gimme
  describe ResolvesMethods do
    describe "#resolve" do
      context "no class on the double" do
        context "plain ol' method" do
          subject { ResolvesMethods.new(nil,:foo,[]) }
          Then { subject.resolve.should == :foo }
        end

        context "using send" do
          subject { ResolvesMethods.new(nil,:send,[:foo]) }
          Then { subject.resolve.should == :foo }
        end
      end

      context "a class is provided" do
        context "rigged to raise errors" do
          context "method exists" do
            subject { ResolvesMethods.new(Berry,:ferment,[]) }
            Then { subject.resolve.should == :ferment }
          end

          context "method does not exist" do
            subject { ResolvesMethods.new(Berry,:fooberry,[]) }
            When(:invocation) { lambda { subject.resolve } }
            Then { invocation.should raise_error NoMethodError, /may not know how to respond/ }
          end

          context "a private method" do
            subject { ResolvesMethods.new(Berry,:grow,[]) }
            When(:invocation) { lambda { subject.resolve } }
            Then { invocation.should raise_error NoMethodError, /not be a great idea/ }
          end
        end

        context "set up not to raise errors" do
          context "method exists" do
            subject { ResolvesMethods.new(Berry,:ferment,[]) }
            When(:result) { subject.resolve(false) }
            Then { result.should == :ferment }
          end

          context "method does not exist" do
            subject { ResolvesMethods.new(Berry,:fooberry,[]) }
            When(:result) { subject.resolve(false) }
            Then { result.should == :fooberry }
          end

          context "a private methods" do
            subject { ResolvesMethods.new(Berry,:grow,[]) }
            When(:result) { subject.resolve(false) }
            Then { result.should == :grow }
          end
        end

      end

    end
  end
end