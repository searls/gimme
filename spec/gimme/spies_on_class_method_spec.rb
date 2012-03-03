require 'spec_helper'

module Gimme
  class ChairFactory

    def self.build
      raise RuntimeError.new "unimplemented feature"
    end

    def self.destroy
      raise RuntimeError.new "unimplemented feature"
    end

  end

  describe SpiesOnClassMethod do
    shared_examples_for "it spies on class methods" do
      describe "normal class method spy" do
        Given(:invocation) { lambda { ChairFactory.build } }
        Then { invocation.should_not raise_error }

        context "upon reset" do
          When { Gimme.reset }
          Then { invocation.should raise_error }
        end

      end

      describe "imaginary class method spy" do
        Given(:invocation) { lambda { ChairFactory.fantasy } }
        Then { invocation.should_not raise_error }

        context "upon reset" do
          When { Gimme.reset }
          Then { invocation.should raise_error }
        end
      end
    end

    context "classical API" do
      it_behaves_like "it spies on class methods" do
        subject { SpiesOnClassMethod.new(ChairFactory) }
        Given { subject.spy(:build) }
        Given { subject.raises_no_method_error = false }
        Given { subject.spy(:fantasy) }
      end
    end

    context "gimme DSL" do
      it_behaves_like "it spies on class methods" do
        Given { spy_on(ChairFactory, :build) }
        Given { spy_on!(ChairFactory, :fantasy) }
      end
    end


  end
end