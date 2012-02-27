module Gimme
  class BlankSlate
    warning_level = $VERBOSE
    $VERBOSE = nil
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    $VERBOSE = warning_level
  end

  class TestDouble < BlankSlate
    attr_accessor :cls
    attr_accessor :stubbings
    attr_reader :invocations

    def initialize(cls=nil)
      @cls = cls
      @stubbings = {}
      @invocations = {}
    end

    def method_missing(sym, *args, &block)
      sym = ResolvesMethods.new(self.cls,sym,args).resolve(false)

      @invocations[sym] ||= {}
      @stubbings[sym] ||= {}

      @invocations[sym][args] = 1 + (@invocations[sym][args]||0)

      InvokesSatisfiedStubbing.new(@stubbings).invoke(sym, args)
    end
  end

end
