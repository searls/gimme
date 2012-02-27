module Gimme
  module DSL
    
    # Instantiation
    
    def gimme(cls=nil)
      Gimme::TestDouble.new(cls)
    end

    def gimme_next(cls)
      double = Gimme::TestDouble.new(cls)
      meta_class = class << cls; self; end
      real_new = cls.method(:new)
      meta_class.send(:define_method,:new) do |*args|
        double.send(:initialize,*args)
        meta_class.send(:define_method,:new,real_new) #restore :new on the class
        double
      end
      double
    end

    
    # Stubbing
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

    # Verification
    def verify(double,times=1)
      Gimme::Verifies.new(double,times)
    end

    def verify!(double,times=1)
      verify = verify(double,times)
      verify.raises_no_method_error = false
      verify
    end
    
  end
end
