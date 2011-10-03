require 'spec_helper'

RSpec::Matchers.define :match do |expected|
  match do |actual|
    actual.matches?(expected)
  end
end

describe Gimme::Matchers do
  class Shoopuf
  end

  class BabyShoopuf < Shoopuf
  end

  describe Matcher do
    context "a plain, default matcher" do
      Given(:matcher) { Gimme::Matchers::Matcher.new }
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

  shared_examples_for "an identity matcher" do
    Then { matcher.should match Shoopuf.new }
    Then { matcher.should match BabyShoopuf.new }
  end

  shared_examples_for "a restrictive matcher" do
    Then { matcher.should_not match nil }
    Then { matcher.should_not match "Pandas" }
    Then { matcher.should_not match Object.new }
    Then { matcher.should_not match Class }
  end

  shared_examples_for "a relaxed matcher" do
    Then { matcher.should match nil }
  end


  describe IsA do
    context "class API" do
      Given(:matcher) { IsA.new(Shoopuf) }
      it_behaves_like "an identity matcher"
      it_behaves_like "a restrictive matcher"
    end

    context "gimme DSL" do
      Given(:matcher) { is_a(Shoopuf) }
      it_behaves_like "an identity matcher"
      it_behaves_like "a restrictive matcher"
    end
  end

  describe Any do
    context "class API" do
      Given(:matcher) { Any.new(Shoopuf) }
      it_behaves_like "an identity matcher"
      it_behaves_like "a relaxed matcher"
    end

    context "gimme DSL" do
      Given(:matcher) { any(Shoopuf) }
      it_behaves_like "an identity matcher"
      it_behaves_like "a relaxed matcher"
    end
  end

  describe Gimme::Matchers::Numeric do
    shared_examples_for "a numeric matcher" do
      Then { matcher.should match 5 }
      Then { matcher.should match 5.5 }
    end

    context "class API" do
      Given(:matcher) { Gimme::Matchers::Numeric.new }
      it_behaves_like "a numeric matcher"
      it_behaves_like "a restrictive matcher"
    end

    context "gimme DSL" do
      Given(:matcher) { numeric }
      it_behaves_like "a numeric matcher"
      it_behaves_like "a restrictive matcher"
    end
  end

  describe Gimme::Matchers::Boolean do
    shared_examples_for "a boolean matcher" do
      Then { matcher.should match true }
      Then { matcher.should match false }
      Then { matcher.should_not match Boolean }
    end

    context "class API" do
      Given(:matcher) { Gimme::Matchers::Boolean.new }
      it_behaves_like "a boolean matcher"
      it_behaves_like "a restrictive matcher"
    end

    context "gimme DSL" do
      Given(:matcher) { boolean }
      it_behaves_like "a boolean matcher"
      it_behaves_like "a restrictive matcher"
    end
  end

end