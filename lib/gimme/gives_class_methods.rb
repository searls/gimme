module Gimme

  class GivesClassMethods < BlankSlate
    attr_accessor :raises_no_method_error
    def initialize(cls)
      @cls = cls
      @raises_no_method_error = true
      @@stubbings = {}
    end

    def method_missing(method, *args, &block)
      cls = @cls
      meta_class = meta_for(@cls)
      method = ResolvesMethods.new(meta_class,method,args).resolve(@raises_no_method_error)
      hidden_method_name = hidden_name_for(method)

      if @cls.respond_to?(method) && !@cls.respond_to?(hidden_method_name)
        meta_class.send(:alias_method, hidden_method_name, method)
      end

      @@stubbings[method] ||= {}
      @@stubbings[method][args] = block if block

      #TODO this will be redundantly overwritten
      meta_class.instance_eval do
        define_method method do |*actual_args|
          InvokesSatisfiedStubbing.new(@@stubbings).invoke(method, actual_args)
        end
      end

      Gimme.on_reset do
        if cls.respond_to?(hidden_method_name)
          meta_class.instance_eval { define_method method, cls.method(hidden_method_name) }
          meta_class.send(:remove_method, hidden_method_name)
        else
          meta_class.send(:remove_method, method)
        end
        @@stubbings.clear
      end
    end

    private

    def meta_for(cls)
      (class << cls; self; end)
    end

    def hidden_name_for(method)
      "__gimme_#{method}"
    end
  end

end
