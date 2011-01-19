module Gimme

  class MethodResolver
    def self.resolve_sent_method(double,sym,args,raises_no_method_error=true)
      cls = double.cls
      sym = args.shift if sym == :send      
      if cls && raises_no_method_error
        if cls.private_methods.include?(sym.to_s)
          raise NoMethodError.new("#{sym} is a private method of your #{cls} test double, so stubbing/verifying it
            might not be a great idea. If you want to try to stub or verify this method anyway, then you can
            invoke give! or verify! to suppress this error.")        
        elsif !cls.instance_methods.include?(sym.to_s)
          raise NoMethodError.new("Your test double of #{cls} may not know how to respond to the '#{sym}' method. 
            If you're confident that a real #{cls} will know how to respond to '#{sym}', then you can
            invoke give! or verify! to suppress this error.")        
        end
      end

      sym
    end
  end

end