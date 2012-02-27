require 'spec_helper'

module Gimme
  describe Captor do
    describe "#value" do
      Given(:captor) { Captor.new }
      When { captor.value = "panda" }
      Then { captor.value.should == "panda" }
    end
  end

  describe Matchers::Capture do
    Given(:captor) { Captor.new }

    shared_examples_for "an argument captor" do
      describe "#matches?" do
        When(:result) { a_capture.matches?("anything at all") }
        Then { result.should == true }
        Then { captor.value.should == "anything at all" }
      end
    end

    context "using the class API" do
      it_behaves_like "an argument captor" do
        Given(:a_capture) { Capture.new(captor) }
      end
    end

    context "using gimme DSL" do
      it_behaves_like "an argument captor" do
        Given(:a_capture) { capture(captor) }
      end
    end
  end
end