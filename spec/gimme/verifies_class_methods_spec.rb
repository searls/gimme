require 'spec_helper'
require 'gimme/shared_examples/shared_verifies_examples'

module Gimme

  describe VerifiesClassMethods do
    class Natto
      def self.ferment(beans=nil,time=nil)
      end
    end

    Given(:test_double) { Natto }
    Given(:double_name) { "#<Class:Gimme::Natto>" }
    Given(:verifier_class) { VerifiesClassMethods }

    context "class API" do
      Given { SpiesOnClassMethod.new(Natto).spy(:ferment) }

      Given(:verifier) { VerifiesClassMethods.new(test_double) }

      it_behaves_like "a verifier"

      it_behaves_like "an overridden verifier" do
        Given do
          s = SpiesOnClassMethod.new(Natto)
          s.raises_no_method_error = false
          s.spy(:eat)
        end
        Given { verifier.raises_no_method_error = false }
      end
    end

    context "gimme DSL" do
      Given { spy_on(Natto, :ferment)}

      it_behaves_like "a verifier" do
        Given(:verifier) { verify(test_double) }
      end

      it_behaves_like "an overridden verifier" do
        Given { spy_on!(Natto, :eat) }
        Given(:verifier) { verify!(test_double) }
      end
    end
  end
end