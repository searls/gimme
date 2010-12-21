module Gimme
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
      sym = MethodResolver.resolve_sent_method(@cls,sym,args)
      args = [args].flatten
      
      @invocations[sym] ||= {}        
      @stubbings[sym] ||= {}
      
      @invocations[sym][args] = 1 + (@invocations[sym][args]||0)

      matched_result = nil
      @stubbings[sym].each do |stub_args,result|
        matching = args.size == stub_args.size
        args.each_index do |i| 
          puts stub_args[i].inspect
          unless args[i] == stub_args[i] || (stub_args[i].matches?(args[i]))
            matching = false
            break
          end
        end        
        matched_result = result if matching
      end
            
      if matched_result
        matched_result
      elsif sym.to_s[-1,1] == '?'
        false
      else
        nil
      end
    end
  end

  class Weres < BlankSlate
    def initialize(double)
      @double = double
    end

    def method_missing(sym, *args, &block)
      sym = MethodResolver.resolve_sent_method(@double.cls,sym,args)
      args = [args].flatten
          
      @double.stubbings[sym] ||= {}
      @double.stubbings[sym][args] = block.call if block
    end
  end

  class Verifies < BlankSlate
    def initialize(double,times=1)
      @double = double
      @times = times
    end

    def method_missing(sym, *args, &block)
      sym = MethodResolver.resolve_sent_method(@double.cls,sym,args)
      args = [args].flatten
            
      invoked = !@double.invocations[sym] ? 0 : (@double.invocations[sym][args]||0) #todo <- make this not the ugliest thing I've ever seen.
      if invoked != @times
        raise VerificationFailedError.new("expected #{sym} to have been called with #{args}")
      end
    end
  end
  
  class MethodResolver
    def self.resolve_sent_method(cls,sym,args)
      sym = args.shift if sym == :send      
      raise NoMethodError.new("Double does not know how to respond to #{sym}") unless cls.instance_methods.include? sym.to_s
      sym
    end
  end

  class VerificationFailedError < StandardError
  end
  
  module Matchers
    class Matcher
      def matches?(arg=nil)
        false
      end
    end

    class Anything < Matcher
      def matches?(arg=nil)
        true
      end
    end
  end

end

def gimme(cls)
  Gimme::TestDouble.new(cls)
end

def were(double)
  Gimme::Weres.new(double)
end

def verify(double,times=1)
  Gimme::Verifies.new(double,times)
end

def anything
  Gimme::Matchers::Anything.new
end
