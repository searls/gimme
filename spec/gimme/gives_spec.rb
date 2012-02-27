require 'spec_helper'
require 'gimme/shared_examples/shared_gives_examples'

describe Gimme::Gives do

  class Bunny
    def nibble
    end

    def eat(food)
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
