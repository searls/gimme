module Gimme
  class Store
    @store = {}

    def initialize
      @store = {}
      Gimme.on_reset(:each) do
        @store.clear
      end
    end

    def reset
      @store = {}
    end

    def set(double, method, args, content)
      id = double.__id__
      @store[id] ||= {}
      @store[id][method] ||= {}

      @store[id][method][args] = content
    end

    def get(double, method=nil, args=nil)
      id = double.__id__
      if !method
        @store[id]
      elsif @store[id] && !args
        @store[id][method]
      elsif @store[id] && @store[id][method]
        @store[id][method][args]
      end
    end

    def clear
      @store.clear
    end
  end
end