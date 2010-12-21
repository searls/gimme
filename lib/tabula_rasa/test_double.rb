module TabulaRasa
  class BlankSlate
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
  end

  class TestDouble < BlankSlate
    attr_accessor :cls
    attr_accessor :stubbings
    attr_reader :invocations

    def initialize(cls)
      @cls = cls
      @stubbings = {}
      @invocations = {}
    end

    def method_missing(sym, *args, &block)
      sym = args.shift if sym == :send      
      raise NoMethodError.new("Double does not know how to respond to #{sym}") unless @cls.instance_methods.include? sym.to_s

      @invocations[sym] ||= {}        
      @invocations[sym][args] = 1 + (@invocations[sym][args]||0)

      @stubbings[sym][args] if @stubbings[sym]
    end
  end

  class Weres < BlankSlate
    def initialize(double)
      @double = double
    end

    def method_missing(sym, *args, &block)
      @double.stubbings[sym] ||= {}
      @double.stubbings[sym][args] ||= block.call if block
    end
  end

  class Verifies < BlankSlate
    def initialize(double,times=1)
      @double = double
      @times = times
    end

    def method_missing(sym, *args, &block)
      sym = args.shift if sym == :send
      raise NoMethodError.new("Double does not know how to respond to #{sym}") unless @double.cls.instance_methods.include? sym.to_s      
      
      invoked = !@double.invocations[sym] ? 0 : @double.invocations[sym][args]      
      if invoked != @times
        raise VerificationFailedError.new("expected #{sym} to have been called with #{args}")
      end
    end
  end
  
  class VerificationFailedError < StandardError
  end

end

def gimme(cls)
  TabulaRasa::TestDouble.new(cls)
end

def were(double)
  TabulaRasa::Weres.new(double)
end

def verify(double,times=1)
  TabulaRasa::Verifies.new(double,times)
end
