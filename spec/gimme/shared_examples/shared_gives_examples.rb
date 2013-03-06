module Gimme
  shared_examples_for "a normal stubbing" do
    describe "stubbing an existing method" do
      context "no args" do
        When { gives.nibble() { "nom" } }
        Then { subject.nibble.should == "nom" }

        context "after reset" do
          When { Gimme.reset }
          Then { subject.nibble.should == nil }
        end
      end

      context "with args" do
        When { gives.eat("carrot") { "crunch" } }
        Then { subject.eat("carrot").should == "crunch" }
        Then { subject.eat("apple").should == nil }
          # Then { lambda{ subject.eat }.should raise_error ArgumentError } # <PENDING

        context "after reset" do
          When { Gimme.reset }
          Then { subject.eat("carrot").should == nil }
        end
      end

      context "with arg matchers" do
        When { gives.eat(is_a(String)) { "yum" } }
        Then { subject.eat("fooberry").should == "yum" }
        Then { subject.eat(15).should == nil }

        context "after reset" do
          When { Gimme.reset }
          Then { subject.eat("fooberry").should == nil }
        end
      end
    end

    describe "stubbing a non-existent method" do
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
end
