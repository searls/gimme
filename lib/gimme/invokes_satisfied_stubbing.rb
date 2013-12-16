module Gimme
  class InvokesSatisfiedStubbing
    def initialize(stubbed_thing)
      @finder = FindsStubbings.new(stubbed_thing)
    end

    def invoke(method, args, block = nil)
      if blk = @finder.find(method, args)
        blk.call(block)
      elsif method.to_s[-1,1] == '?'
        false
      else
        nil
      end
    end
  end
end
