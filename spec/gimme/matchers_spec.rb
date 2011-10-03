require 'spec_helper'

RSpec::Matchers.define :match do |expected|
  match do |actual|
    actual.matches?(expected)
  end
end

describe Gimme::Matchers do
  describe Matcher do
    context "a plain, default matcher" do
      Given(:matcher) { Matcher.new }
      Then { matcher.should_not match "anything" }
    end
  end

  describe Anything do
    shared_examples_for "an anything matcher" do
      Then { matcher.should match "anything" }
    end

    context "class API" do
      it_behaves_like "an anything matcher" do
        Given(:matcher) { Anything.new }
      end
    end

    context "gimme DSL" do
      it_behaves_like "an anything matcher" do
        Given(:matcher) { anything }
      end
    end
  end

  describe IsA do

    class Shoopuf
    end

    class BabyShoopuf < Shoopuf
    end

    shared_examples_for "an identity matcher" do
      context "the argument is a matching type" do
        Then { matcher.should match Shoopuf.new }
      end

      context "the argument is not a matching type" do
        Then { matcher.should_not match "Some other class" }
      end

      context "the argument is a subclass of the type" do
        Then { matcher.should match BabyShoopuf.new }
      end
    end

    Given(:matcher) { IsA.new(Shoopuf) }

  end


end