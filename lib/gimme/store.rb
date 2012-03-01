module Gimme
  class Store
    @store = {}

    def initialize
      @store = {}

    end

    def reset
      @store = {}
    end

    def set(double, method, args, content)
      @store[double] ||= {}
      @store[double][method] ||= {}
      @store[double][method][args] ||= content
    end

    def get(double, method=nil, args=nil)
      @store[double]
      @store[double][method] if method
      @store[double][method][args] if method && args
    end

    def clear
      @store.clear
    end
  end
end