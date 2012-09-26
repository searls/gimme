module Gimme
  class InvokesSatisfiedStubbing
    def initialize(stubbed_thing)
      @finder = FindsStubbings.new(stubbed_thing)
    end

    def invoke(method, args)
      if blk = @finder.find(method, args)
        blk.call
      elsif method.to_s[-1,1] == '?'
        false
      else
        nil
      end
    end
  end
end
