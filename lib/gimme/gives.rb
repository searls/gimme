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

end
