module Gimme

  class ClassMethodStore < Store

    def set(cls, method_name)
      id = cls.__id__
      meta = (class << cls; self; end)
      @store[id] ||= {}

      if meta.method_defined?(method_name) && !@store[id][method_name]
        @store[id][method_name] = cls.method(method_name)
      end
    end

  end

  def self.class_methods
    @@class_methods ||= ClassMethodStore.new
  end

end