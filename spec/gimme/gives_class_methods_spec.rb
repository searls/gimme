require 'spec_helper'

describe Gimme::GivesClassMethods do
  class Bunny
    def self.nibble
    end

    def self.eat(food)
    end
  end

  shared_examples_for "a normal class method stubbing" do
    describe "stubbing an existing method" do
      context "no args" do
        When { gives.nibble() { "nom" } }
        Then { subject.nibble.should == "nom" }
      end

      context "with args" do
        When { gives.eat("carrot") { "crunch" } }
        Then { subject.eat("carrot").should == "crunch" }
        Then { subject.eat("apple").should == nil }
        Then { lambda{ subject.eat }.should raise_error ArgumentError }
      end

    end

    describe "stubbing a non-existent class method" do
      When(:stubbing) {  lambda { gives.bark { "woof" } } }
      Then { stubbing.should raise_error NoMethodError  }
    end

  end

  shared_examples_for "an overridden class method stubbing" do
    context "configured to _not_ raise an error when stubbed method does not exist" do
      Given { gives.raises_no_method_error =false }
      When { gives.bark { "woof" } }
      Then { subject.bark.should == "woof" }
    end
  end

  context "using the class API" do
    Given(:subject) { Bunny }

    it_behaves_like "a normal class method stubbing" do
      Given(:gives) { GivesClassMethods.new(subject) }
    end

    it_behaves_like "an overridden class method stubbing" do
      Given(:gives) { GivesClassMethods.new(subject) }
    end
  end

  context "using the gimme DSL" do
    Given(:subject) { Bunny }

    it_behaves_like "a normal class method stubbing" do
      Given(:gives) { give(subject) }
    end

    it_behaves_like "an overridden class method stubbing" do
      Given(:gives) { give!(subject) }
    end
  end
end
