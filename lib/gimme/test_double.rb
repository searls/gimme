module Gimme
  class BlankSlate
    warning_level = $VERBOSE
    $VERBOSE = nil
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    $VERBOSE = warning_level
  end

  class TestDouble < BlankSlate
    attr_accessor :cls

    def initialize(cls=nil)
      @cls = cls
    end

    def method_missing(method, *args, &block)
      method = ResolvesMethods.new(self.cls, method, args).resolve(false)
      Gimme.invocations.increment(self, method, args)
      InvokesSatisfiedStubbing.new(Gimme.stubbings.get(self)).invoke(method, args)
    end
  end

end
