require 'spec_helper'
require 'gimme/shared_examples/shared_gives_examples'

module Gimme
  describe GivesClassMethods do

    class Bunny
      def self.nibble
      end

      def self.eat(food)
      end
    end

    class FooFoo < Bunny
    end

    class Rabbit
      def self.eat(food)
      end
    end

    describe "two classes with similar stubbings" do
      Given { give(Rabbit).eat("carrot") { "yum" } }
      Given { give(Bunny).eat("carrot") { "yay" } }
      Then { Rabbit.eat("carrot").should == "yum" }
      Then { Bunny.eat("carrot").should == "yay" }
    end

    context "using the class API" do
      Given(:subject) { Bunny }

      it_behaves_like "a normal stubbing" do
        Given(:gives) { GivesClassMethods.new(subject) }
      end

      it_behaves_like "an overridden stubbing" do
        Given(:gives) { GivesClassMethods.new(subject) }
      end

      context "on subclasses" do
        Given(:subject) { FooFoo }

        it_behaves_like "a normal stubbing" do
          Given(:gives) { GivesClassMethods.new(subject) }
        end

        it_behaves_like "an overridden stubbing" do
          Given(:gives) { GivesClassMethods.new(subject) }
        end
      end
    end

    context "using the gimme DSL" do
      Given(:subject) { Bunny }

      it_behaves_like "a normal stubbing" do
        Given(:gives) { give(subject) }
      end

      it_behaves_like "an overridden stubbing" do
        Given(:gives) { give!(subject) }
      end

      context "on subclasses" do
        Given(:subject) { FooFoo }

        it_behaves_like "a normal stubbing" do
          Given(:gives) { give(subject) }
        end

        it_behaves_like "an overridden stubbing" do
          Given(:gives) { give!(subject) }
        end
      end
    end
  end
end
