require 'spec_helper'
require 'gimme/shared_examples/shared_verifies_examples'

module Gimme

  describe Verifies do
    class Natto
      def ferment(beans=nil,time=nil)
      end
    end

    Given(:test_double) { gimme(Natto) }

    context "class API" do
      Given(:verifier) { Verifies.new(test_double) }
      it_behaves_like "a verifier"
      it_behaves_like "an overridden verifier" do
        Given { verifier.raises_no_method_error = false }
      end
    end

    context "gimme DSL" do
      it_behaves_like "a verifier" do
        Given(:verifier) { verify(test_double) }
      end

      it_behaves_like "an overridden verifier" do
        Given(:verifier) { verify!(test_double) }
      end
    end
  end
end