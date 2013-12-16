require 'spec_helper'

module Gimme
  describe TestDouble do
    describe "#gimme_next" do
      class MassiveDamage
        def boom
          :asplode
        end
      end

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

    describe "#gimme" do
      context "of a class" do
        subject { gimme(Object) }
        Then { subject.should == subject }
        Then { subject.eql?(subject).should == true }
        Then { subject.to_s.should == "<#Gimme:1 Object>" }
        Then { subject.inspect.should == "<#Gimme:1 Object>" }
        Then { {}.tap {|h| h[subject] = subject }[subject].should == subject }
      end

      context "with a string name" do
        subject { gimme("pants") }
        Given { give(subject).name { "pants" } }
        Then { subject.to_s.should == "<#Gimme:1 pants>" }
        Then { subject.name.should == "pants" }
      end

      context "when called with a block" do
        subject { gimme }

        Given do
          give(subject).process {|blk| blk.call }
        end

        Then do
          obj_in_block = false
          subject.process { obj_in_block = true }
          obj_in_block.should be_true
        end
      end
    end
  end
end
