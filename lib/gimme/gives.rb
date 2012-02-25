module Gimme
  @@class_stubbings_to_nuke = []

  def self.reset
    @@class_stubbings_to_nuke.delete_if do |stubbing|
      cls = stubbing[:cls]
      meta = (class << stubbing[:cls]; self; end)
      if cls.respond_to?(stubbing[:hidden_method_name])
        meta.instance_eval { define_method stubbing[:method_name], cls.method(stubbing[:hidden_method_name]) }
        meta.send(:remove_method, stubbing[:hidden_method_name])
      else
        meta.send(:remove_method, stubbing[:method_name])
      end
      true
    end
  end

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
      meta_for(@cls).instance_eval { define_method method, &block if block }

      @@class_stubbings_to_nuke << {
        :cls => @cls,
        :meta => meta_for(@cls),
        :method_name => method,
        :hidden_method_name => hidden_name_for(method)
      }

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
