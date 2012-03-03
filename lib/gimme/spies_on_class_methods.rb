module Gimme
  class SpiesOnClassMethod
    def initialize(cls)
      @cls = cls
    end

    def spy(method)
      Gimme.class_methods.set(@cls, method)
      meta_class = (class << @cls; self; end)
      meta_class.send(:remove_method, method)

      meta_class.instance_eval do
        define_method method do |*args|
          #Gimme.invocations.increment(@cls, method, args)
        end
      end

      EnsuresClassMethodRestoration.new(@cls).ensure(method)
    end
  end
end