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
      Given(:invocation) { lambda { ChairFactory.build } }
      Then { invocation.should_not raise_error }

      context "upon reset" do
        When { Gimme.reset }
        Then { invocation.should raise_error }
      end
    end

    context "classical API" do
      it_behaves_like "it spies on class methods" do
        Given { SpiesOnClassMethod.new(ChairFactory).spy(:build) }
      end
    end

    # context "gimme DSL" do
    #   it_behaves_like "it spies on class methods" do
    #     Given(:spy) { spy_on(ChairFactory, :build) }
    #   end
    # end


  end
end