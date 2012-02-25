module Gimme

  class Gives < BlankSlate
    attr_accessor :raises_no_method_error
    def initialize(double)
      @double = double
      @raises_no_method_error = true
    end

    def method_missing(sym, *args, &block)
      sym = MethodResolver.resolve_sent_method(@double,sym,args,@raises_no_method_error)

      @double.stubbings[sym] ||= {}
      @double.stubbings[sym][args] = block if block
    end
  end

  class GivesClassMethods < BlankSlate
    attr_accessor :raises_no_method_error
    def initialize(cls)
      @cls = cls
      @raises_no_method_error = true
    end

    def method_missing(method, *args, &block)
      method = MethodResolver.resolve_sent_method(meta_for(@cls),method,args,@raises_no_method_error)
      if @cls.respond_to?(method) && !@cls.respond_to?(hidden_name_for(method))
        meta_for(@cls).send(:alias_method, hidden_name_for(method), method)
      end
      meta_for(@cls).instance_eval { define_method method, &block }

      # RSpec.configure do |c|
      #   c.after(:each) do
      #     meta.instance_eval { define_method method, @cls.method(hidden_name) }
      #     meta.send(:remove_method, hidden_name)
      #   end
      # end

      #@double.stubbings[sym] ||= {}
      #@double.stubbings[sym][args] = block if block
    end

    private

    def meta_for(cls)
      (class << cls; self; end)
    end

    def hidden_name_for(method)
      "__gimme_#{method}"
    end
  end

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
end
