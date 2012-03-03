module Gimme

  class GivesClassMethods < BlankSlate
    attr_accessor :raises_no_method_error
    def initialize(cls)
      @cls = cls
      @raises_no_method_error = true
    end

    def method_missing(method, *args, &block)
      cls = @cls
      meta_class = (class << cls; self; end)
      method = ResolvesMethods.new(meta_class,method,args).resolve(@raises_no_method_error)

      Gimme.class_methods.set(cls, method)
      Gimme.stubbings.set(cls, method, args, block)

      #TODO this will be redundantly overwritten
      meta_class.instance_eval do
        define_method method do |*actual_args|
          InvokesSatisfiedStubbing.new(Gimme.stubbings.get(cls)).invoke(method, actual_args)
        end
      end

      Gimme.on_reset do
        if real_method = Gimme.class_methods.get(@cls, method)
          meta_class.instance_eval { define_method method, real_method }
        else
          meta_class.send(:remove_method, method)
        end
      end
    end

  end

end
