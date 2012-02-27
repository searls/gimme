module Gimme

  class Gives < BlankSlate
    attr_accessor :raises_no_method_error
    def initialize(double)
      @double = double
      @raises_no_method_error = true
    end

    def method_missing(sym, *args, &block)
      sym = ResolvesMethods.new(@double.cls,sym,args).resolve(@raises_no_method_error)

      @double.stubbings[sym] ||= {}
      @double.stubbings[sym][args] = block if block
    end
  end

  def give(double)
    if double.kind_of? Class
      Gimme::GivesClassMethods.new(double)
    else
      Gimme::Gives.new(double)
    end
  end

  def give!(double)
    give = give(double)
    give.raises_no_method_error = false
    give
  end
end
