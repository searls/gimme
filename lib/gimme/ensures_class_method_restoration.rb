module Gimme
  class EnsuresClassMethodRestoration
    def initialize(cls)
      @cls = cls
    end

    def ensure(method)
      meta_class = (class << @cls; self; end)
      Gimme.on_reset do
        if original_method = Gimme.class_methods.get(@cls, method)
          restored_method = restored_method(meta_class, original_method)
          meta_class.instance_eval { define_method method, &restored_method }
        else
          meta_class.send(:remove_method, method)
        end
      end
    end

    private

    def restored_method(meta_class, original_method)
      if meta_class == original_method.owner
        original_method
      else
        lambda { |*args| super *args }
      end
    end
  end
end
