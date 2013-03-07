module Gimme
  class EnsuresClassMethodRestoration
    def initialize(cls)
      @cls = cls
    end

    def ensure(method)
      meta_class = (class << @cls; self; end)
      Gimme.on_reset do
        if real_method = Gimme.class_methods.get(@cls, method)
          real_method.owner.instance_eval { define_method method, real_method }
        else
          meta_class.send(:remove_method, method)
        end
      end
    end
  end
end
