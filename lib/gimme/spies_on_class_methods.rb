module Gimme
  class SpiesOnClassMethod
    attr_accessor :raises_no_method_error
    def initialize(cls)
      @cls = cls
      @raises_no_method_error = true
    end

    def spy(method)
      meta_class = (class << @cls; self; end)
      method = ResolvesMethods.new(meta_class, method).resolve(@raises_no_method_error)

      if meta_class.method_defined? method
        Gimme.class_methods.set(@cls, method)
        meta_class.send(:remove_method, method)
      end

      cls = @cls
      meta_class.instance_eval do
        define_method method do |*args|
          Gimme.invocations.increment(cls, method, args)
        end
      end

      EnsuresClassMethodRestoration.new(@cls).ensure(method)
    end
  end
end