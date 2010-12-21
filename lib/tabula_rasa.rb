module TabulaRasa
  class BlankSlate
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
  end
  
  class Stub < BlankSlate
    attr_accessor :stubbings
    attr_reader :invocations
    
    def initialize(cls)
      @cls = cls
      @stubbings = {}
      @invocations = {}
    end
    
    def method_missing(sym, *args, &block)
      raise NoMethodError.new("Stub does not know how to respond to #{sym}") unless @cls.new.respond_to? sym
      
      @invocations[sym] ||= {}        
      @invocations[sym][args] = 1 + (@invocations[sym][args]||0)
      
      @stubbings[sym][args]     
    end
  end
  
  class Whenner < BlankSlate
    def initialize(double)
      @double = double
    end
    
    def method_missing(sym, *args, &block)
      @double.stubbings[sym] ||= {}
      @double.stubbings[sym][args] ||= block.call if block
    end
  end
  
  class Verifier < BlankSlate
    def initialize(double,times=1)
      @double = double
      @times = times
    end
    
    def method_missing(sym, *args, &block)
      if !@double.invocations[sym] || @double.invocations[sym][args] < @times
        raise StandardError.new("expected #{sym} to have been called with #{args}")
      end
    end
  end

end

def were(double)
  TabulaRasa::Whenner.new(double)
end

def verify(double)
  TabulaRasa::Verifier.new(double)
end

s = TabulaRasa::Stub.new(Object)
were(s).to_s { 'pants' }
  
puts s.to_s

verify(s).to_s