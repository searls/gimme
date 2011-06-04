module Gimme

  class Gives < BlankSlate
    attr_accessor :raises_no_method_error
    def initialize(double)
      @double = double
      @raises_no_method_error = true
    end

    def method_missing(sym, *args, &block)
      sym = MethodResolver.resolve_sent_method(@double,sym,args,@raises_no_method_error)

      @double.stubbings[sym] ||= {}
      @double.stubbings[sym][args] = block if block
    end
  end

  def give(double)
    Gimme::Gives.new(double)
  end

  def give!(double)
    give = give(double)
    give.raises_no_method_error = false
    give
  end
end
