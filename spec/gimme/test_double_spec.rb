require 'spec_helper'

module Gimme
  describe TestDouble do
    class MassiveDamage
      def boom
        :asplode
      end
    end

    describe "#gimme_next" do
      Given(:test_double) { gimme_next(MassiveDamage) }
      Given(:subject) { MassiveDamage.new }

      Given { give(test_double).boom { :kaboom } }
      When(:result) { subject.boom }
      Then { result.should == :kaboom }

      context "subsequent uses" do
        Given(:next_subject) { MassiveDamage.new }
        When(:next_result) { next_subject.boom }
        Then { next_result.should == :asplode }
      end
    end

  end
end