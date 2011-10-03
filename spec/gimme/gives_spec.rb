require 'spec_helper'

describe Gimme::Gives do
  class Bunny
    def nibble
    end
  end

  shared_examples_for "a normal stubbing" do
    context "stubbing an existing method" do
      When { gives.nibble() { "nom" } }
      Then { subject.nibble.should == "nom" }
    end

    context "stubbing a non-existent method" do
      When(:stubbing) {  lambda { gives.bark { "woof" } } }
      Then { stubbing.should raise_error NoMethodError  }
    end
  end

  shared_examples_for "an overridden stubbing" do
    context "configured to _not_ raise an error when stubbed method does not exist" do
      Given { gives.raises_no_method_error =false }
      When { gives.bark { "woof" } }
      Then { subject.bark.should == "woof" }
    end
  end

  context "using the class API" do
    Given(:subject) { TestDouble.new(Bunny) }

    it_behaves_like "a normal stubbing" do
      Given(:gives) { Gives.new(subject) }
    end

    it_behaves_like "an overridden stubbing" do
      Given(:gives) { Gives.new(subject) }
    end
  end

  context "using the gimme DSL" do
    Given(:subject) { gimme(Bunny) }

    it_behaves_like "a normal stubbing" do
      Given(:gives) { give(subject) }
    end

    it_behaves_like "an overridden stubbing" do
      Given(:gives) { give!(subject) }
    end
  end
end
